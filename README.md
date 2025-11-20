# LazyRecon

**LazyRecon** is a simple, fast, and automated reconnaissance tool written in Bash for cybersecurity researchers and CTF players.

It collects and reports basic OSINT data about a target domain with a single command.

## Features
* **WHOIS:** Fetches domain registration details.
* **DNS Enumeration:** Lists A, MX, and TXT records.
* **HTTP Headers:** Analyzes server versions and security headers.
* **Robots.txt:** Checks for hidden directories and files.
* **Reporting:** Saves all outputs to an organized directory (`/reports`).

## Installation (Linux)

```bash
git clone [https://github.com/YOUR_USERNAME/LazyRecon.git](https://github.com/YOUR_USERNAME/LazyRecon.git)
cd LazyRecon
chmod +x lazyrecon.sh
