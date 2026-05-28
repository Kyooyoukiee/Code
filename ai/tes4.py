from transformers import pipeline

pipe = pipeline("text-generation", model="deepseek-ai/DeepSeek-V4-Pro")
messages = [
    {"role": "user", "content": "Who are you?"},
]
pipe(messages)