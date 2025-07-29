INSERT INTO users (
    id,
    username,
    password_hash,
    password_salt,
    full_name,
    business_name,
    about,
    based_in,
    joined_on
) VALUES (
    @Id,
    @Username,
    @PasswordHash,
    @PasswordSalt,
    @FullName,
    @BusinessName,
    @About,
    @BasedIn,
    @JoinedOn
);