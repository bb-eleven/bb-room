# BB Room for 11th Coy

Website for managing inventory.

## Running locally

1. Install packages\
   `npm i`
2. Make sure Docker is running\
   `dockerd` on Linux, Docker app on Mac/Windows
3. Start Supabase locally\
   `npx supabase start`\
   Take note of `API URL` and `anon key`
4. Create `.env.local` file with the following properties\
   `VITE_SUPABASE_URL='<API URL>'`\
   `VITE_SUPABASE_ANON_KEY='<anon key>'`
