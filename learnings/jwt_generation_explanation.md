# 🔑 How JWT Tokens are Generated (Code Walkthrough)

When an employee successfully logs into the system with their email and password, the Spring Boot backend must create a secure, tamper-proof "ticket" for them. This ticket is the **JSON Web Token (JWT)**.

Here is exactly where and how that token is forged in the code.

---

## The Origin File
The exact file responsible for generating and signing tokens is:
`backend/src/main/java/com/dealerconnect/dms/security/JwtTokenProvider.java`

You can explain the process by breaking the file down into 3 critical steps.

### Step 1: Loading the Cryptographic Secret
Before generating a token, the server needs a heavily guarded secret key.
```java
@Value("${jwt.secret}")
private String jwtSecret;

private Key key;

@PostConstruct
public void init() {
    // This converts your secret text into a cryptographic HMAC SHA Key
    this.key = Keys.hmacShaKeyFor(jwtSecret.getBytes());
}
```
**Explanation:** When the application boots up (`@PostConstruct`), it reads the `jwt.secret` from the `application.yml` file. It mathematically converts this string into a high-security `Key` object using the HMAC algorithm. *If a hacker doesn't have this exact key, they can never forge a fake token.*

### Step 2: Sorting the Roles and Permissions
When `generateToken(UserDetails userDetails...)` is called, Spring Security hands over all the information it knows about the user. But it's all jumbled together in a list called "Authorities".
```java
String role = userDetails.getAuthorities().stream()
    .map(GrantedAuthority::getAuthority)
    .filter(a -> a.startsWith("ROLE_")) // Extract only the Base Role
    .findFirst().orElse("");

List<String> permissions = userDetails.getAuthorities().stream()
    .map(GrantedAuthority::getAuthority)
    .filter(a -> !a.startsWith("ROLE_")) // Extract everything else (permissions)
    .collect(Collectors.toList());
```
**Explanation:** The code splits the user's data into two distinct buckets. 
1. It loops through the authorities and finds the single string starting with `"ROLE_"` (e.g., `ROLE_SALES_MANAGER`).
2. It loops through again and grabs all the granular permissions (e.g., `SALES_VIEW`, `EMPLOYEES_EDIT`).

### Step 3: Forging the JWT Payload (The Builder)
Now that the data is sorted, the code uses the `io.jsonwebtoken` library (JJWT) to physically build the token.
```java
return Jwts.builder()
    .setSubject(userDetails.getUsername())        // Typically the user's Email
    .claim("role", role)                          // Adds the Base Role
    .claim("permissions", permissions)            // Adds the Array of Permissions
    .claim("dealerId", dealerId)                  // Locks them to a Dealership
    .claim("isSuperAdmin", isSuperAdmin)          // Special flag for system owners
    .setIssuedAt(new Date())
    .setExpiration(new Date(System.currentTimeMillis() + jwtExpirationMs)) // Expires in X hours
    .signWith(key, SignatureAlgorithm.HS256)      // CRYPTOGRAPHIC LOCK
    .compact();                                   // Compresses into a Base64 string
```
**Explanation Breakdown:**
*   **The Claims:** The `.claim()` methods literally pack the JSON payload with data. This is how the Angular frontend later knows what Dealership the user belongs to and what buttons to show/hide.
*   **The Expiration:** `.setExpiration()` calculates the current time plus the configured allowed hours (e.g., 24 hours). After this exact millisecond, the token self-destructs and the user is logged out.
*   **The Signature (`.signWith`)**: This is the magic line. It takes the entire payload, mashes it against your secret `key` from Step 1, and runs the `HS256` hashing algorithm on it. This guarantees that if a user tries to modify their token in the browser (e.g., changing their dealer ID from `1` to `2`), the signature will instantly become invalid, and Spring Security will reject the hacking attempt.
*   **`.compact()`**: Finally, it squashes all this JSON and cryptographic data into the classic 3-part Base64 URL string (e.g., `eyJh...`) that you see in your browser's Local Storage!