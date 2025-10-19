-- Create students table for email validation
-- This table should contain all valid student emails

CREATE TABLE IF NOT EXISTS students (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  first_name TEXT,
  last_name TEXT,
  university TEXT,
  student_id TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create an index on email for faster lookups
CREATE INDEX IF NOT EXISTS idx_students_email ON students(email);

-- Insert some sample student emails (replace with your actual student emails)
INSERT INTO students (email, first_name, last_name, university, student_id) VALUES
('john.doe@university.edu', 'John', 'Doe', 'University', 'STU001'),
('jane.smith@university.edu', 'Jane', 'Smith', 'University', 'STU002'),
('mike.johnson@university.edu', 'Mike', 'Johnson', 'University', 'STU003')
ON CONFLICT (email) DO NOTHING;

-- Enable Row Level Security (RLS) for the students table
ALTER TABLE students ENABLE ROW LEVEL SECURITY;

-- Create a policy that allows anyone to read student emails (for validation)
CREATE POLICY "Allow public read access for email validation" ON students
  FOR SELECT USING (true);

-- Create a policy that only allows service role to insert/update/delete
CREATE POLICY "Service role can manage students" ON students
  FOR ALL USING (auth.role() = 'service_role');

-- Optional: Create a function to check if an email is a valid student email
CREATE OR REPLACE FUNCTION is_student_email(email_to_check TEXT)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM students 
    WHERE email = LOWER(email_to_check)
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission on the function to authenticated users
GRANT EXECUTE ON FUNCTION is_student_email(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION is_student_email(TEXT) TO anon;
