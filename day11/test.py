from functools import cache

@cache
def rules(n):
    if n == 0:
        return [1]
    if len(str(n)) % 2 == 0:
        m = len(str(n)) // 2
        return [int(str(n)[0:m]), int(str(n)[m:])]
    return [n*2024]

@cache
def f(d, n):
    if d == 0:
        return 1
    r = rules(n)
    if len(r) == 1:
        return f(d-1,r[0])
    return f(d-1,r[0]) + f(d-1,r[1])

s = 0
for i in [17639, 47, 3858, 0, 470624, 9467423, 5, 188]:
    s += f(75, i)

print(s)
