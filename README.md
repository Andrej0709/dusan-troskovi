# Troškovi

Personal expense dashboard: expenses with categories and payment methods, subscriptions, filtering and sorting, and weekly/monthly recaps.

A static site with no build step. On Vercel, import the repo with framework preset "Other" and no build command.

## Database (Supabase)

1. Create a project at supabase.com.
2. Open SQL Editor, paste `supabase/schema.sql` and run it.
3. In Project Settings → API copy the Project URL and the `anon` `public` key into `config.js`.
4. Commit and push; Vercel redeploys.

If `config.js` is empty or the database can't be reached, the app falls back to the browser's `localStorage`. Data saved there before Supabase was set up can be moved into the database with one click on the Overview tab.

**There is no login.** The anon key is visible in the page source, so anyone who has the site URL can read, change and delete the data. Never put the `service_role` key in `config.js`.
