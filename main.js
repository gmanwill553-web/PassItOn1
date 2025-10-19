const {createClient} = require('@supabase/supabase-js')
const supabaseUrl = 'https://sfbjtumnvjhjhdderaiv.supabase.co'
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNmYmp0dW1udmpoamhkZGVyYWl2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA3OTg4MTcsImV4cCI6MjA3NjM3NDgxN30.JCC14-o5gRk6avAYYCIidQKNO5MkIRVfauPFEAkP_ts'
const supabase = createClient(supabaseUrl, supabaseKey)

async function getStudents() {
    const {data, error} = await supabase
        .from('students')
        .select('*')
        if (error) {
            console.error('Error fetching users:', error)
        } else {
            console.log('Students:', data)
        }
        }
getStudents()