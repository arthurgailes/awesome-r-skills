# Tool/Function Calling in ellmer

## Overview

Chat models can request external tool execution. **The chat model does not directly execute any external tools!** Instead, models request that callers execute functions, then return results for the model to incorporate into responses.

## Key Conceptual Distinction

**Incorrect**: User → Assistant executes code → Result back to user
**Correct**: User → Assistant requests tool call → User executes → Assistant uses results

The model's value lies in determining when tools are useful, selecting appropriate arguments, and leveraging results.

## Practical Implementation

### Defining Tools

Functions become tools through wrapping with `tool()`, requiring:
- Function reference
- Name and description
- Argument specifications using type functions

`create_tool_def()` can auto-generate these definitions using an LLM, though human review remains necessary.

### Registration and Usage

Tools integrate via `chat$register_tool()`. Once registered, models autonomously decide when invocation is appropriate.

### Input/Output Specifications

**Inputs** must use: `type_boolean()`, `type_integer()`, `type_number()`, `type_string()`, `type_enum()`, `type_array()`, or `type_object()`.

**Outputs** should remain simple—text or atomic vectors. Complex data automatically serializes to JSON. For direct JSON control, wrap results in `I()`.

## Advanced Capabilities

### Data Structures

Tools can return data frames that ellmer converts to JSON row-major format, optimized for LLM comprehension.

### Multimodal Support

Tools may return images or PDFs via `content_image_file()` and similar functions, enabling vision capabilities when API-supported.

## Example Applications

- Current time retrieval for temporal reasoning
- Weather API simulation with batch city queries
- Website screenshots for visual analysis

Each example demonstrates autonomous tool invocation—models independently recognize when tools solve problems effectively.
