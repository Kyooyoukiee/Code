from transformers import pipeline
import torch

pipe = pipeline(
    "text-generation",
    model="meta-llama/Llama-3.2-3B-Instruct",
    device_map="cpu",
    torch_dtype=torch.float32
)

result = pipe(
    "Halo",
    max_new_tokens=20
)

print(result[0]["generated_text"])