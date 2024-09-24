
primes = []

def is_prime(n):
     if n <= 1:
         return False
     if n <= 3:
         return True
     if n % 2 == 0 or n % 3 == 0:
         return False
     i = 5
     while i * i <= n:
         if n % i == 0 or n % (i + 2) == 0:
             return False
         i += 6
     return True

possible_prime = 1
while len(primes) < 100000:
    if is_prime(possible_prime):
        primes.append(possible_prime)

    possible_prime += 1

    if possible_prime > 10 ** 7:
        print(primes)
        print("Maximum limit reached.")
        print(len(primes))
        exit(5)

print(primes)
print("success")
