print("Hello World")
print("This is a simple Python program.")
print("It demonstrates basic syntax and output.")
print("You can run this code to see the output.")
print("Feel free to modify and experiment with the code!")
print("Happy coding!")

print(3 + 4)  # This will output 7
print(10 - 2)  # This will output 8
print(5 * 6)  # This will output 30
print(20 / 4)  # This will output 5.0
print("The result of 3 + 4 is:", 3 + 4)
print("The result of 10 - 2 is:", 10 - 2)
print("The result of 5 * 6 is:", 5 * 6)
print("The result of 20 / 4 is:", 20 / 4)
# This is a comment in Python. It is ignored by the interpreter.
# You can use comments to explain your code or to temporarily disable code.
# This program demonstrates basic arithmetic operations and output in Python.

class SimpleCalculator:
    def add(self, a, b):
        return a + b

    def subtract(self, a, b):
        return a - b

    def multiply(self, a, b):
        return a * b

    def divide(self, a, b):
        if b != 0:
            return a / b
        else:
            return "Cannot divide by zero"

calculator = SimpleCalculator()
print("Addition:", calculator.add(3, 4))
print("Subtraction:", calculator.subtract(10, 2))
print("Multiplication:", calculator.multiply(5, 6))
print("Division:", calculator.divide(20, 4))