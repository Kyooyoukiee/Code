from transformers import pipeline

pipe = pipeline(
    "text-generation",
    model="TinyLlama/TinyLlama-1.1B-Chat-v1.0"
)

result = pipe("Halo", max_new_tokens=50)

print(result[0]["generated_text"])