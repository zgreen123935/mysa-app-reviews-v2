# Mysa-App-Reviews-v2

A serverless application that fetches app reviews from the App Store and Google Play Store and posts them to Slack.

## Project Structure

```
Mysa-App-Reviews-v2/
├── README.md
├── api/
│   └── fetch-reviews.rb      # Serverless endpoint
├── lib/
│   ├── mock_data.rb         # Mock review data
│   └── review_processor.rb  # Review processing logic
└── test_locally.rb         # Local testing script
```

## Local Development

1. Install dependencies:
```bash
bundle install
```

2. Create a `.env` file with your credentials:
```bash
cp .env.template .env
# Edit .env with your credentials
```

3. Run the local test:
```bash
ruby test_locally.rb
```

## Deployment to Vercel

1. Push your code to GitHub:
```bash
git remote add origin <your-github-repo-url>
git push -u origin main
```

2. Connect your GitHub repository to Vercel:
   - Go to [Vercel](https://vercel.com)
   - Click "New Project"
   - Import your GitHub repository
   - Configure the project:
     - Framework Preset: Other
     - Build Command: `./build.sh`
     - Output Directory: `api`

3. Add Environment Variables in Vercel:
   - Copy all variables from `.env.template`
   - Add them in Vercel's project settings under "Environment Variables"

4. Deploy!
   - Vercel will automatically deploy your project
   - Your API endpoint will be available at: `https://<your-project>.vercel.app/api/fetch-reviews`

## Setting up Cron Job

To automatically fetch reviews periodically:

1. Sign up at [cron-job.org](https://cron-job.org)
2. Create a new cron job:
   - URL: `https://<your-project>.vercel.app/api/fetch-reviews`
   - Schedule: Every 6 hours (or your preferred interval)
   - Method: GET

## License

This project is private and confidential.
