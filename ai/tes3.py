import ollama

while True:
    msg = input("You: ")

    response = ollama.chat(
        model='tinyllama',
        messages=[
            {'role': 'user', 'content': msg}
        ]
    )

    print("AI:", response['message']['content'])