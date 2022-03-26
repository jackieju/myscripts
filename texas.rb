# return C m,n  m > n
def fact(m, n)
    if (m-n < n)
        n = m-n
    end

    p (m-n+1..m).inject(:*)
    p (1..n).inject(:*)
    return (m-n+1..m).inject(:*)/(1..n).inject(:*)
end

p fact(7, 4 )
    