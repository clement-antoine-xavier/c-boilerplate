# C Boilerplate

## Description

This repository provides a **C boilerplate template** designed to streamline the development of C-based applications. It includes a robust **Makefile** with flags for optimization, security, debugging, testing, and static analysis. This boilerplate is perfect for anyone starting a new C project, offering tools for high-quality, secure, and optimized code from the get-go.

---

## Features

- **Automated Build System** with `Makefile`:
  - Compilation with security and performance optimizations.
  - Link-Time Optimization (LTO) for better performance.
  - Static analysis using `clang-tidy` to ensure clean code.
  - Unit testing and code coverage with `lcov` and `gcov`.
  
- **Security Enhancements**:
  - Stack protection with `-fstack-protector-all`.
  - Memory leak and undefined behavior detection using **sanitizers**.
  - Fortification flags for safer code (`-D_FORTIFY_SOURCE=2`).

- **Debugging & Profiling**:
  - Debug symbols enabled with `-g3 -ggdb` for GDB.
  - Address and Undefined Behavior sanitizers for runtime checks.
  - Profiling support with `-pg` for performance analysis.

- **Code Quality Checks**:
  - Automated **coding style** check (integrate your own style checker).
  - Static analysis with `clang-tidy`.

---

## How to Use

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/clement-antoine-xavier/c-boilerplate.git
   cd c-boilerplate
   ```

2. **Build the Project**:
   - To compile and build the application:

     ```bash
     make
     ```

3. **Run the Unit Tests**:
   - To run the tests:

     ```bash
     make tests_run
     ```

4. **Generate Code Coverage Report**:
   - After running tests, generate the code coverage report:

     ```bash
     make coverage
     ```

5. **Static Analysis**:
   - Run static analysis on the source code:

     ```bash
     make static-analysis
     ```

6. **Clean the Build**:
   - Clean the project (remove object files and compiled executables):

     ```bash
     make clean
     ```

7. **Remove All Artifacts**:
   - Remove all build artifacts, including executables:

     ```bash
     make fclean
     ```

---

## Makefile Targets

- **all**: Build the C project.
- **clean**: Clean the object files and coverage files.
- **fclean**: Clean all build artifacts (including executable).
- **re**: Clean and rebuild everything from scratch.
- **debug**: Build with debugging symbols and sanitizers enabled.
- **tests_run**: Run the unit tests with coverage tracking.
- **coverage**: Generate a code coverage report.
- **static-analysis**: Run static analysis using `clang-tidy`.
- **coding-style**: Check coding style with a custom style checker.

---

## Requirements

- **GCC** (GNU Compiler Collection)
- **Make** (Build automation tool)
- **clang-tidy** (Static code analysis tool)
- **lcov** and **gcov** (Code coverage tools)

Ensure these tools are installed on your system before building the project.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Contributing

Feel free to fork this repository, create issues, and submit pull requests. Contributions are welcome!

---

## Acknowledgements

This boilerplate template was created with best practices in mind, helping you build secure, efficient, and maintainable C applications. It's a starting point for building a wide variety of C projects, from simple applications to more complex systems.
