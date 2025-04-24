# README

## Overview
This guide explains how to configure Git and Go to seamlessly fetch private Go modules from GitHub using SSH authentication.

## Prerequisites
- A GitHub account with access to the private repository (e.g., `github.com/sasha-riabchuk/sendl-proto`).
- Git and Go (1.13+) installed on your system.
- An SSH key pair (`id_rsa`/`id_rsa.pub`) available locally or generate a new one.

## 1. Generate an SSH Key (if needed)
```bash
# Check for existing keys
ls ~/.ssh/id_*.pub

# If none, generate a new key
ssh-keygen -t ed25519 -C "your_email@example.com"
# Press Enter to accept defaults and set a passphrase if desired
```

## 2. Add Your SSH Key to GitHub
1. Copy the public key to clipboard:
   ```bash
   cat ~/.ssh/id_ed25519.pub | pbcopy  # macOS
   # or use xclip on Linux
   ```
2. In GitHub, go to **Settings** → **SSH and GPG keys** → **New SSH key**.
3. Paste the key and save.

## 3. Configure Git to Use SSH for GitHub
```bash
# Rewrite HTTPS URLs to SSH globally
git config --global url."git@github.com:".insteadOf "https://github.com/"
```

## 4. Instruct Go to Treat Your Module as Private
```bash
# In your shell startup (e.g., ~/.bashrc or ~/.zshrc)
export GOPRIVATE=github.com/sasha-riabchuk/*
# Reload your shell:
source ~/.bashrc  # or ~/.zshrc
```

## 5. Fetch the Private Module
```bash
go get github.com/sasha-riabchuk/sendl-proto
# or in a module-aware project:
go mod tidy
```

## 6. (Optional) Dockerfile Snippet
If you build inside Docker, pass your SSH agent or key and set GOPRIVATE:
```Dockerfile
# syntax=docker/dockerfile:1

FROM golang:1.20 AS builder

ARG GOPRIVATE=github.com/sasha-riabchuk/*
ENV GOPRIVATE=$GOPRIVATE

# Enable SSH forwarding
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh

# Use BuildKit SSH mount:
# docker build --ssh default .
RUN --mount=type=ssh git config --global url."git@github.com:".insteadOf "https://github.com/"

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o /sendl-post-service
```

---

Now you can fetch and build private Go modules without entering credentials each time.

