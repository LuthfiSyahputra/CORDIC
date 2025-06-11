from graphviz import Digraph

# Create a Digraph object
dot = Digraph(comment='Fixed-Point 5-bit Divider')

# Input section
dot.node('A', 'Dividend (5-bit)', shape='rectangle')
dot.node('B', 'Divisor (3-bit)', shape='rectangle')
dot.node('AS', 'Abs / Sign Logic', shape='parallelogram')

# Registers and control
dot.node('QR', 'Quotient Register (Q)', shape='rectangle')
dot.node('RR', 'Remainder Register (R)', shape='rectangle')
dot.node('CNT', 'Counter', shape='ellipse')
dot.node('CTRL', 'Control FSM', shape='ellipse')

# Subtract and shift unit
dot.node('SUB', 'Subtractor', shape='diamond')
dot.node('MUX', 'MUX\n(R or R - D)', shape='diamond')
dot.node('SHL', 'Shift Left\n(QR, R)', shape='diamond')

# Output
dot.node('QO', 'Quotient Out', shape='rectangle')
dot.node('RO', 'Remainder Out', shape='rectangle')

# Connections
dot.edges([('A', 'AS'), ('B', 'AS')])
dot.edge('AS', 'QR', label='Q init')
dot.edge('AS', 'RR', label='R init')
dot.edge('CTRL', 'CNT', label='Count')
dot.edge('RR', 'SUB', label='R')
dot.edge('B', 'SUB', label='D')
dot.edge('SUB', 'MUX', label='R - D')
dot.edge('RR', 'MUX', label='R')
dot.edge('MUX', 'RR', label='R <- MUX out')
dot.edge('MUX', 'CTRL', label='Sign Bit')
dot.edge('CTRL', 'QR', label='Set Q[i]')
dot.edge('QR', 'SHL')
dot.edge('RR', 'SHL')
dot.edge('SHL', 'QR')
dot.edge('SHL', 'RR')
dot.edge('QR', 'QO')
dot.edge('RR', 'RO')

# Save to file
output_path = "fixed_point_divider"
# output_path + ".png"
dot.render(output_path, format='png', cleanup=True)

