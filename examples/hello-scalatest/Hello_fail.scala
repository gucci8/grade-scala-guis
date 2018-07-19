package example

trait Output {
    def print(s: String) = Console.println(s)
}

class Hello extends Output {
    def hello() = print("Hello world!")
}
