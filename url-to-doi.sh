#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Convert URL to DOI
# @raycast.mode silent
# @raycast.packageName Browser
#
# Optional parameters:
# @raycast.icon 🔗
#
# Documentation:
# @raycast.description Extracts a DOI from a clipboard URL by first scraping the page metadata,
#                      then falling back to a DOI pattern in the URL itself. Verifies and copies the result.
# @raycast.author Jan Valosek, Claude Code

url=$(pbpaste | tr -d '[:space:]')

if [ -z "$url" ]; then
    echo "Clipboard is empty"
    exit 1
fi

# Already a DOI URL — nothing to do
if [[ "$url" == "https://doi.org/"* ]]; then
    echo "Already a DOI URL: $url"
    exit 0
fi

doi=""

# ── arXiv: construct DOI from the arXiv ID before fetching anything ───────────
# Handles both abstract (/abs/) and PDF (/pdf/) URLs.
# Must run first — the PDF page HTML contains cited-paper DOIs which would mislead scraping.
if [[ "$url" == *"arxiv.org/abs/"* ]] || [[ "$url" == *"arxiv.org/pdf/"* ]]; then
    arxiv_id=$(echo "$url" | sed 's|.*arxiv\.org/\(abs\|pdf\)/||' | sed 's|[?#v\.].*||;s|\(.*\)\.\(.*\)|\1.\2|' )
    # Simpler: grab everything after /abs/ or /pdf/, strip query/fragment/version
    arxiv_id=$(echo "$url" | grep -oE 'arxiv\.org/(abs|pdf)/[0-9]+\.[0-9]+' | grep -oE '[0-9]+\.[0-9]+')
    doi="10.48550/arXiv.${arxiv_id}"
fi

# ── Phase 1: fetch the page and look for DOI in standard meta tags ────────────
if [ -z "$doi" ]; then
html=$(curl -sL --max-time 15 \
    -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36" \
    "$url")
fi

if [ -z "$doi" ] && [ -n "$html" ]; then
    # <meta name="citation_doi" content="..."> — most publishers
    doi=$(echo "$html" | grep -oi 'name="citation_doi"[^>]*content="[^"]*"\|content="[^"]*"[^>]*name="citation_doi"' \
        | grep -oE '10\.[0-9]{4,}/[^"]+' | head -1)

    # <meta name="DC.Identifier" content="..."> — Dublin Core
    if [ -z "$doi" ]; then
        doi=$(echo "$html" | grep -oi 'name="DC\.Identifier"[^>]*content="[^"]*"\|content="[^"]*"[^>]*name="DC\.Identifier"' \
            | grep -oE '10\.[0-9]{4,}/[^"]+' | head -1)
    fi

    # Any doi.org/10.XXXX/... link in the HTML (stop at quote, space, query char, or punctuation)
    if [ -z "$doi" ]; then
        doi=$(echo "$html" | grep -oE 'doi\.org/10\.[0-9]{4,}/[^"<> ?&)]+' \
            | head -1 | sed 's|doi\.org/||')
    fi
fi

# ── Phase 2: fall back to extracting a DOI pattern directly from the URL ──────
# Covers sites behind Cloudflare / JS rendering (e.g. MIT Direct, Springer).
if [ -z "$doi" ]; then
    doi=$(echo "$url" | grep -oE '10\.[0-9]{4,}/[^/?&#[:space:]]+')
fi

if [ -z "$doi" ]; then
    echo "Could not find a DOI for: $url"
    exit 1
fi

# Strip bioRxiv / medRxiv version suffixes (e.g. "v2")
doi=$(echo "$doi" | sed 's/v[0-9]*$//')

# Strip any trailing punctuation that may have leaked in from surrounding HTML text
doi=$(echo "$doi" | sed 's/[).,;:>]*$//')

doi_url="https://doi.org/${doi}"

# ── Verify: doi.org returns 301/302 for valid DOIs ────────────────────────────
http_code=$(curl -sI -o /dev/null -w "%{http_code}" --max-time 10 "$doi_url")

if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 400 ]; then
    echo "$doi_url" | pbcopy
    echo "Copied: $doi_url"
else
    echo "Warning: DOI returned HTTP $http_code — copied anyway: $doi_url"
    echo "$doi_url" | pbcopy
fi
