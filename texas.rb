# return C m,n  m > n

# calc permutation and combination

def A(m,n)
    if (m-n < n)
        n = m-n
    end
    (m-n+1..m).inject(:*)
end
def C(m, n)
    if (m-n < n)
        n = m-n
    end

   # p (1..n).inject(:*)
    return A(m,n)/(1..n).inject(:*)
end

#p fact(7, 4 )
m = $*[0].to_i
n = $*[1].to_i
if m <= n
    p "m must greater than n"
    return
end

p "A #{A(m, n)}"
p "C #{C(m, n)}"