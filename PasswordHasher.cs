using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Web;

namespace QualityControlAssessment
{
    public class PasswordHasher
    {
        private const int Iterations = 100000;
        private const int SaltBytes = 16;
        private const int HashBytes = 32;

        public static void CreateHash(string password, out byte[] hash, out byte[] salt)
        {
            if (string.IsNullOrEmpty(password))
                throw new ArgumentException("Password is required.", "password");

            salt = new byte[SaltBytes];
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(salt);
            }

            hash = DeriveKey(password, salt);
        }

        public static bool Verify(string password, byte[] storedHash, byte[] storedSalt)
        {
            if (string.IsNullOrEmpty(password) || storedHash == null || storedSalt == null)
                return false;

            byte[] candidate = DeriveKey(password, storedSalt);
            return FixedTimeEquals(candidate, storedHash);
        }

        private static byte[] DeriveKey(string password, byte[] salt)
        {
            using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, Iterations, HashAlgorithmName.SHA256))
            {
                return pbkdf2.GetBytes(HashBytes);
            }
        }

        private static bool FixedTimeEquals(byte[] a, byte[] b)
        {
            if (a == null || b == null || a.Length != b.Length)
                return false;

            int difference = 0;
            for (int i = 0; i < a.Length; i++)
            {
                difference |= a[i] ^ b[i];
            }

            return difference == 0;
        }
    }
}