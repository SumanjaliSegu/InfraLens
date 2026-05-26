# 🔬 InfraLens — AI-Powered Incident Post-Mortem Generator

InfraLens ingests raw incident data (server logs, Slack threads, Jira tickets) and produces a structured post-mortem in seconds — root cause, evidence citations, action items, and confidence score — powered by GPT-4o and a RAG pipeline.

## ⚡ Quick Start (Demo — no API key needed)

```bash
pip install -r requirements.txt
streamlit run ui/app.py
```

Click **"Run Live Demo"** — a pre-loaded database outage scenario runs instantly with no uploads or API key required.

## 🔑 Full AI Mode (GPT-4o)

```bash
cp .env.example .env
# Add OPENAI_API_KEY to .env

# Terminal 1 — API
uvicorn api.main:app --reload

# Terminal 2 — UI
streamlit run ui/app.py
```

## 🏗 Architecture

```
Logs + Slack + Tickets
        │
   Ingestion Layer          Pattern recognition: DB pool, OOM, circuit breakers,
   (log/slack/ticket        replication lag, deployments, recovery events
    parsers)
        │
   Timeline Builder         Unified chronological event stream
        │
   RAG Layer                ChromaDB vector store · text-embedding-3-small
   embedder / retriever     5-minute window chunking
        │
   LangGraph Agent          GPT-4o · tool-calling loop
   tools:                   search_timeline() · search_past_incidents()
        │
   FastAPI + Streamlit      REST API + dark-mode UI · PDF export
```

## 📁 Project Structure

```
infralens/
├── agent/          LangGraph agent, prompts, tool definitions
├── api/            FastAPI REST endpoint
├── data/raw/       Sample incident data (DB outage scenario)
├── ingestion/      Log parser (pattern recognition), Slack, ticket parsers
├── rag/            Embedder, ChromaDB store, retriever
├── ui/             Streamlit interface with demo mode + PDF export
└── evaluation/     RAGAS eval framework (WIP)
```

## 🛠 Tech Stack

- **LangGraph** — agent loop with conditional tool-calling
- **GPT-4o** — reasoning and structured output
- **ChromaDB** — vector store for timeline chunks and incident memory
- **FastAPI** — REST API backend
- **Streamlit** — frontend with demo mode
- **ReportLab** — PDF post-mortem export

## 📊 Sample Output (DB Outage Scenario)

- **Root cause:** Connection leak in order-service v2.4.1 (unclosed transactions in exception handler)
- **Duration:** 11 minutes
- **Evidence:** 42 log events + 18 Slack messages + 4 tickets correlated
- **Action items:** 4 tasks with owners and priorities
- **Confidence:** HIGH
