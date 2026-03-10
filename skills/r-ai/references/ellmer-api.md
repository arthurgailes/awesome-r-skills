# ellmer API Reference

Complete function reference for the ellmer package.

## Chatbots

| Function | Purpose |
|----------|---------|
| `chat()` | Initialize a chat session with any provider |
| `chat_anthropic()` / `chat_claude()` | Connect to Anthropic Claude models |
| `models_claude()` / `models_anthropic()` | List available Claude models |
| `chat_aws_bedrock()` | Access models through AWS Bedrock |
| `models_aws_bedrock()` | Enumerate AWS Bedrock available models |
| `chat_azure_openai()` | Connect to Azure-hosted OpenAI models |
| `chat_cloudflare()` | Access CloudFlare-hosted models |
| `chat_databricks()` | Connect to Databricks-hosted models |
| `chat_deepseek()` | Access DeepSeek-hosted models |
| `chat_github()` | Use GitHub model marketplace |
| `models_github()` | List GitHub marketplace models |
| `chat_google_gemini()` / `chat_google_vertex()` | Connect to Google Gemini or Vertex AI |
| `models_google_gemini()` / `models_google_vertex()` | Enumerate Google model options |
| `chat_groq()` | Access Groq-hosted models |
| `chat_huggingface()` | Connect to Hugging Face Inference API |
| `chat_mistral()` | Use Mistral's La Platforme |
| `models_mistral()` | List Mistral models |
| `chat_ollama()` | Run local Ollama models |
| `models_ollama()` | List local Ollama models |
| `chat_openai()` | Connect to OpenAI models |
| `models_openai()` | Enumerate OpenAI models |
| `chat_openai_compatible()` | Access OpenAI-compatible endpoints |
| `chat_openrouter()` | Use OpenRouter model marketplace |
| `chat_perplexity()` | Connect to perplexity.ai models |
| `chat_portkey()` | Access PortkeyAI-hosted models |
| `models_portkey()` | List PortkeyAI models |
| `chat_snowflake()` | Connect to Snowflake-hosted models |
| `chat_vllm()` | Use vLLM-hosted models |
| `models_vllm()` | List vLLM available models |
| `Chat` | Core chat object with methods for messaging |
| `token_usage()` | Track token consumption during session |

**Example:**
```r
library(ellmer)

# Create chat
chat <- chat_openai(model = "gpt-4o")

# Send message
chat$chat("Explain R's pipe operator")

# Get token usage
token_usage(chat)
```

## Provider-Specific Helpers

| Function | Purpose |
|----------|---------|
| `google_upload()` | Upload files to Gemini |
| `claude_file_upload()` | Upload files for Claude use |
| `claude_file_list()` | View Claude-uploaded files |
| `claude_file_get()` | Retrieve Claude file metadata |
| `claude_file_download()` | Download Claude files |
| `claude_file_delete()` | Remove Claude files |
| `claude_tool_web_search()` | Enable Claude web search capability |
| `claude_tool_web_fetch()` | Enable Claude URL fetching |
| `google_tool_web_search()` | Enable Google web search |
| `google_tool_web_fetch()` | Enable Google URL fetching |
| `openai_tool_web_search()` | Enable OpenAI web search |

**Example:**
```r
# Upload file to Claude
claude_file_upload("data.csv")

# Enable web search
chat$set_tools(claude_tool_web_search())
```

## Chat Helpers

| Function | Purpose |
|----------|---------|
| `create_tool_def()` | Generate tool metadata specifications |
| `content_image_url()` / `content_image_file()` / `content_image_plot()` | Prepare images for chat input |
| `content_pdf_file()` / `content_pdf_url()` | Prepare PDF content for chat input |
| `live_console()` / `live_browser()` | Open interactive chat interfaces |
| `interpolate()` / `interpolate_file()` / `interpolate_package()` | Insert data into prompts |

**Example:**
```r
# Send image
chat$chat(
  "What's in this image?",
  content_image_file("plot.png")
)

# Interactive chat
live_console(chat)

# Interpolate data into prompt
interpolate("Summarize: {{data}}", data = df)
```

## Parallel and Batch Chat

| Function | Purpose |
|----------|---------|
| `batch_chat()` | Submit multiple chat requests together |
| `batch_chat_text()` | Batch submit for text responses |
| `batch_chat_structured()` | Batch submit for structured outputs |
| `batch_chat_completed()` | Check batch completion status |
| `parallel_chat()` | Submit concurrent chat requests |
| `parallel_chat_text()` | Parallel submit for text responses |
| `parallel_chat_structured()` | Parallel submit for structured outputs |

**Example:**
```r
# Process multiple prompts in parallel
results <- parallel_chat_text(
  chat,
  prompts = c("Explain R", "Explain Python", "Explain Julia")
)
```

## Tools and Structured Data

| Function | Purpose |
|----------|---------|
| `tool()` | Define callable tool specifications |
| `tool_annotations()` | Add metadata to tool definitions |
| `tool_reject()` | Decline a tool invocation |
| `type_boolean()` / `type_integer()` / `type_number()` / `type_string()` / `type_enum()` / `type_array()` / `type_object()` | Define parameter types |
| `type_from_schema()` | Generate type from JSON schema |
| `type_ignore()` | Skip type validation |

**Example:**
```r
# Define tool
calc_tool <- tool(
  name = "calculator",
  parameters = list(
    a = type_number("First number"),
    b = type_number("Second number"),
    op = type_enum(c("+", "-", "*", "/"), "Operation")
  ),
  fn = function(a, b, op) {
    switch(op,
      "+" = a + b,
      "-" = a - b,
      "*" = a * b,
      "/" = a / b
    )
  }
)

chat$set_tools(calc_tool)
```

## Objects

| Class | Purpose |
|-------|---------|
| `Provider` | Abstract provider implementation |
| `Turn` / `UserTurn` / `SystemTurn` / `AssistantTurn` | Message turn representations |
| `Content` types | Represent text, images, PDFs, tools, and thinking |
| `Type` definitions | Schema for function parameters |

## Utilities

| Function | Purpose |
|----------|---------|
| `contents_text()` / `contents_html()` / `contents_markdown()` | Format outputs as text |
| `contents_record()` / `contents_replay()` | Record and restore conversations |
| `df_schema()` | Generate data frame schema descriptions |
| `params()` | Configure standard model parameters |

**Example:**
```r
# Record conversation
contents_record(chat, "conversation.rds")

# Replay later
chat_new <- chat_openai()
contents_replay(chat_new, "conversation.rds")

# Generate schema from data frame
df_schema(mtcars)
```

## Documentation

**Package site:** https://ellmer.tidyverse.org/
**GitHub:** https://github.com/tidyverse/ellmer
