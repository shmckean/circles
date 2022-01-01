# Calculates and plots circles of Apollonius
# Based on GW Coakley's 1860 paper:
# "Analytical Solutions of the Ten Problems in the Tangencies of Circles..."
# The Mathematical Monthly. 2: 116–126.

k = QQ;       # input base field
x = PolynomialRing(k.algebraic_closure(),'x').gen();
a = [2,0,-2]; # input x-coords of circle centers
b = [0,3,-1]; # input y-coords of circle centers
r = [1,1,2];  # input radii of circles

def A_1(a,b,r,s):
    F = (a[0]-a[1])*(b[0]-b[2])-(a[0]-a[2])*(b[0]-b[1])
    return(((s[0]*r[0]-s[1]*r[1])*(b[0]-b[2])-(s[0]*r[0]-s[2]*r[2])*(b[0]-b[1]))*k(F).inverse_of_unit())

def B_1(a,b,r,s):
    F = (a[0]-a[1])*(b[0]-b[2])-(a[0]-a[2])*(b[0]-b[1])
    return(((s[0]*r[0]-s[2]*r[2])*(a[0]-a[1])-(s[0]*r[0]-s[1]*r[1])*(a[0]-a[2]))*k(F).inverse_of_unit())

def A_2(a,b,r,s):
    D = a[0]^2-a[1]^2+b[0]^2-b[1]^2-(r[0]^2-r[1]^2)
    E = a[0]^2-a[2]^2+b[0]^2-b[2]^2-(r[0]^2-r[2]^2)
    F = (a[0]-a[1])*(b[0]-b[2])-(a[0]-a[2])*(b[0]-b[1])
    return(((b[0]-b[2])*D-(b[0]-b[1])*E)*k(2*F).inverse_of_unit())

def B_2(a,b,r,s):
    D = a[0]^2-a[1]^2+b[0]^2-b[1]^2-(r[0]^2-r[1]^2)
    E = a[0]^2-a[2]^2+b[0]^2-b[2]^2-(r[0]^2-r[2]^2)
    F = (a[0]-a[1])*(b[0]-b[2])-(a[0]-a[2])*(b[0]-b[1])
    return(((a[0]-a[1])*E-(a[0]-a[2])*D)*k(2*F).inverse_of_unit())

def R(a,b,r,s):
    A1 = A_1(a,b,r,s)
    A2 = A_2(a,b,r,s)
    B1 = B_1(a,b,r,s)
    B2 = B_2(a,b,r,s)
    m = A2+A1*s[0]*r[0]-a[0]
    n = B2+B1*s[0]*r[0]-b[0]
    f = (x-s[0]*r[0])^2*(1-A1^2-B1^2)-2*(m*A1+n*B1)*(x-s[0]*r[0])-m^2-n^2
    rts = [u[0] for u in f.roots()]
    return(rts)

def reality(a,b,r):
    return((a in RR) and (b in RR) and (r in RR))

signs = [];
for i in range(8):
    s = [];
    for j in format(i,'03b'):
        s.append((-1)^int(j));
    signs.append(s);

g = Graphics()

for i in range(3):
    if reality(a[i],b[i],r[i]):
        g += circle((a[i],b[i]),r[i],rgbcolor=(0,0,0));

for s in signs:
    Rad = R(a,b,r,s);
    A1 = A_1(a,b,r,s);
    A2 = A_2(a,b,r,s);
    B1 = B_1(a,b,r,s);
    B2 = B_2(a,b,r,s);
    print('s:',s)
    if len(Rad) < 2: print('double circle')
    print('a:',A1*Rad[0]+A2)
    print('b:',B1*Rad[0]+B2)
    print('r:',Rad[0],'\n')
    if reality(A1*Rad[0]+A2,B1*Rad[0]+B2,Rad[0]):
        g += circle((A1*Rad[0]+A2,B1*Rad[0]+B2),Rad[0],rgbcolor=((s[0]+1)/3,(s[1]+1)/3,(s[2]+1)/3),linestyle='--');

g