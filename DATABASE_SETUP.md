# Database Connection Setup

This project is now connected to your Supabase PostgreSQL database. Here's what has been set up:

## Files Created

1. **`src/lib/supabase.ts`** - Supabase client configuration
2. **`src/lib/database.ts`** - Database utility class with common operations
3. **`src/components/DatabaseTest.tsx`** - Test component to verify connection
4. **`src/examples/database-usage.ts`** - Usage examples

## Database Configuration

- **Host**: `db.sfbjtumnvjhjhdderaiv.supabase.co`
- **Port**: `5432`
- **Database**: `postgres`
- **Username**: `postgres`
- **Password**: `ByteDownForce##25`

## Next Steps

### 1. Get Your Supabase Anon Key

You need to get your Supabase anon key from your Supabase dashboard:

1. Go to your Supabase project dashboard
2. Navigate to Settings → API
3. Copy the "anon public" key
4. Replace `'your_anon_key_here'` in `src/lib/supabase.ts` with your actual key

### 2. Test the Connection

The database test component is already added to your homepage. You can:

1. Run `npm run dev` to start the development server
2. Visit your homepage
3. Click "Test Database Connection" to verify everything works

### 3. Create Your Database Schema

You'll need to create tables in your Supabase database. You can do this through:

- **Supabase Dashboard**: Go to Table Editor and create tables manually
- **SQL Editor**: Write SQL commands to create tables
- **Migration files**: Use Supabase CLI for version-controlled schema changes

### 4. Example Schema for Book Exchange

Here's a suggested schema for your book exchange application:

```sql
-- Users table
CREATE TABLE users (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  university TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Books table
CREATE TABLE books (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  author TEXT NOT NULL,
  isbn TEXT,
  condition TEXT CHECK (condition IN ('new', 'like_new', 'good', 'fair', 'poor')),
  price DECIMAL(10,2) NOT NULL,
  description TEXT,
  image_url TEXT,
  seller_id UUID REFERENCES users(id) ON DELETE CASCADE,
  status TEXT DEFAULT 'available' CHECK (status IN ('available', 'sold', 'pending')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Transactions table
CREATE TABLE transactions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  book_id UUID REFERENCES books(id) ON DELETE CASCADE,
  buyer_id UUID REFERENCES users(id) ON DELETE CASCADE,
  seller_id UUID REFERENCES users(id) ON DELETE CASCADE,
  price DECIMAL(10,2) NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'cancelled')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Messages table for communication
CREATE TABLE messages (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  transaction_id UUID REFERENCES transactions(id) ON DELETE CASCADE,
  sender_id UUID REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## Usage Examples

### Basic Query
```typescript
import { getDatabaseClient } from '@/lib/database'
import { QueryClient } from '@tanstack/react-query'

const queryClient = new QueryClient()
const dbClient = getDatabaseClient(queryClient)

// Get all available books
const books = await dbClient.query('books', {
  filters: { status: 'available' },
  orderBy: { column: 'created_at', ascending: false },
  limit: 20
})
```

### React Query Integration
```typescript
import { useQuery } from '@tanstack/react-query'
import { getDatabaseClient } from '@/lib/database'

const useBooks = () => {
  return useQuery({
    queryKey: ['books'],
    queryFn: async () => {
      const queryClient = new QueryClient()
      const dbClient = getDatabaseClient(queryClient)
      return dbClient.query('books')
    }
  })
}
```

### Real-time Updates
```typescript
import { supabase } from '@/lib/supabase'

// Subscribe to book changes
const subscription = supabase
  .channel('books_changes')
  .on('postgres_changes', 
    { event: '*', schema: 'public', table: 'books' },
    (payload) => {
      console.log('Book change:', payload)
    }
  )
  .subscribe()
```

## Security Notes

- Never expose your service role key in client-side code
- Use Row Level Security (RLS) policies in Supabase for data protection
- Validate all user inputs before database operations
- Use environment variables for sensitive configuration in production

## Troubleshooting

If you encounter connection issues:

1. Verify your Supabase project is active
2. Check that your anon key is correct
3. Ensure your database URL is properly formatted
4. Check Supabase dashboard for any service issues
5. Review browser console for detailed error messages

Your database connection is now ready to use! 🎉
