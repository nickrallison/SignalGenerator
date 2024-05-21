import math
import os
import sys
import sympy as sym

def twos_complement(n, bits):
    """Compute the 2's complement of a number within a certain bit width."""
    mask = (1 << bits) - 1
    if n < 0:
        n = (~abs(n) + 1) & mask
    return n 

if __name__ == "__main__":
    
    
    file_in = sys.argv[1]
    file_out = sys.argv[2]

    module_name_in = os.path.basename(file_in).split(".")[0]
    module_name_out = os.path.basename(file_out).split(".")[0]
    
    data_width = 8    ## or 2**8 possible values
    num_samples = 256
    fraction_of_1_period = 1
    
    ## Format from x = [0, 1], and y = [-1, 1]
    equation = sym.sin(2 * sym.pi * sym.Symbol('x'))
    max_value = 2**(data_width - 1) - 1
    
    values = []
    for i in range(num_samples):
        x_value = i / num_samples
        equation_value = math.ceil(max_value * equation.subs(sym.Symbol('x'), x_value).evalf())
        equation_value = twos_complement(equation_value, data_width)
        values.append(equation_value)
    
    string = "{" + ", ".join([f"{data_width}'d" + str(x) for x in values]) + "}"
    with open(file_in, 'r') as f:
        contents = f.read()
    
    contents = contents.replace("#[data_cell]", string)
    contents = contents.replace(f"module {module_name_in}", f"module {module_name_out}")
    with open(file_out, 'w') as f:
        f.write(contents)
    
    