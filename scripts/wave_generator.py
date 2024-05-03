import math
import os
import sympy as sym

if __name__ == "__main__":
    
    data_width = 8    ## or 2**8 possible values
    num_samples = 256
    fraction_of_1_period = 0.25
    
    ## Format from x = [0, 1], and y = [-1, 1]
    equation = sym.sin(1/2 * sym.pi * sym.Symbol('x'))
    max_value = 2**data_width - 1
    
    values = []
    for i in range(num_samples):
        x_value = i / num_samples
        equation_value = math.ceil(max_value * equation.subs(sym.Symbol('x'), x_value).evalf())
        values.append(equation_value)
    
    with open(os.path.join("build", "waveform.mem"), "w") as f:
        for value in values:
            f.write(f"{value}\n")
    