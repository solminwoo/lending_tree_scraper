# lending_tree_scraper engineering guidance

<!-- ecc-engineering-defaults:start -->
## Engineering defaults
For coding work, read [.engineering/defaults.md](.engineering/defaults.md).
These are shared fallback conventions; the existing project owner, nested instructions,
skills, model choices, domain contracts and stronger verification/release gates remain authoritative.
No hooks, permissions, MCP services or background automation are installed by this guidance.

### Project adaptation
Ruby scraper with Gemfile.lock and RSpec under `spec/`. Candidate check: `bundle exec rspec` after reviewing fixtures for network calls. Keep scraping offline during routine tests; preserve lockfile and source-site boundaries.
<!-- ecc-engineering-defaults:end -->
