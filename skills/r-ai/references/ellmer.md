# ellmer Reference

## Providers

| Function | Provider | API Key Env Var |
|----------|----------|-----------------|
| `chat_openai()` | OpenAI | `OPENAI_API_KEY` |
| `chat_anthropic()` | Anthropic | `ANTHROPIC_API_KEY` |
| `chat_google_gemini()` | Google | `GOOGLE_API_KEY` |
| `chat_ollama()` | Ollama (local) | None |
| `chat_azure_openai()` | Azure OpenAI | `AZURE_OPENAI_API_KEY` + endpoint |
| `chat_bedrock()` | AWS Bedrock | AWS credentials |
| `chat_groq()` | Groq | `GROQ_API_KEY` |
| `chat_mistral()` | Mistral | `MISTRAL_API_KEY` |
| `chat_deepseek()` | DeepSeek | `DEEPSEEK_API_KEY` |
| `chat_databricks()` | Databricks | Databricks auth |
| `chat_snowflake()` | Snowflake | Snowflake auth |

## Chat Object Methods

```r
chat <- chat_openai(model = "gpt-4o")

# Conversation
chat$chat("prompt")                    # Interactive (streams to console)
chat$chat("prompt", echo = "none")     # Capture response programmatically
chat$chat("prompt", echo = "text")     # Stream text only (no tool calls)

# Tools
chat$set_tools(list(tool1, tool2))     # Register tools
chat$get_tools()                       # List registered tools

# History
chat$get_turns()                       # Get conversation history
chat$set_turns(turns)                  # Replace history
```

## Model Selection

```r
# OpenAI
chat_openai(model = "gpt-4o")          # Latest GPT-4
chat_openai(model = "gpt-4o-mini")     # Faster, cheaper

# Anthropic
chat_anthropic(model = "claude-sonnet-4-20250514")
chat_anthropic(model = "claude-opus-4-20250514")

# Azure OpenAI (requires endpoint + deployment name)
chat_azure_openai(
  endpoint = "https://your-resource.openai.azure.com",
  deployment_id = "your-gpt4-deployment",
  api_version = "2024-02-01"
)

# Ollama (local)
chat_ollama(model = "llama3.2")        # General purpose
chat_ollama(model = "codellama")       # Code-focused
chat_ollama(model = "mistral")         # Fast inference
```

## Defining Tools

```r
# Function becomes a tool via type_*() annotations
my_tool <- function(
  city = type_string("City name to look up"),
  units = type_enum("Temperature units", values = c("celsius", "fahrenheit"))
) {
  # Implementation
  paste0("Weather in ", city, ": 72", units)
}

chat$set_tools(list(my_tool))
chat$chat("What's the weather in Paris?")  # LLM calls my_tool
```

## Multimodal (Images)

```r
chat$chat(
  content_image_url("https://example.com/image.png"),
  "What's in this image?"
)

chat$chat(
  content_image_file("local/image.png"),
  "Describe this"
)
```

## Streaming and Async

```r
# Stream handler
chat$chat("prompt", stream = function(chunk) {
  cat(chunk)
})

# Batch processing (multiple prompts)
prompts <- c("Question 1", "Question 2", "Question 3")
responses <- chat$batch(prompts)
```

## Cost Tracking

```r
chat$chat("prompt")
chat$get_cost()  # Returns cost estimate for session
```
