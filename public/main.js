document.addEventListener('DOMContentLoaded', function() {
    const sendMockDataBtn = document.getElementById('sendMockData');
    const loadingSpinner = document.getElementById('loadingSpinner');
    const buttonText = document.getElementById('buttonText');
    const resultMessage = document.getElementById('resultMessage');
    const resultMessageContent = resultMessage.querySelector('div');
    const lastTestedTime = document.getElementById('lastTestedTime');
    const slackStatus = document.getElementById('slackStatus');

    // Check Slack configuration on load
    checkSlackConfig();

    sendMockDataBtn.addEventListener('click', async function() {
        // Disable button and show loading state
        sendMockDataBtn.disabled = true;
        loadingSpinner.classList.remove('hidden');
        buttonText.textContent = 'Sending...';
        resultMessage.classList.add('hidden');

        try {
            const response = await fetch('/api/fetch-reviews');
            const data = await response.json();

            // Update last tested time
            const now = new Date();
            lastTestedTime.textContent = `Last tested: ${now.toLocaleString()}`;

            // Show success message
            resultMessage.classList.remove('hidden');
            resultMessageContent.classList.remove('bg-red-100', 'text-red-700');
            resultMessageContent.classList.add('bg-green-100', 'text-green-700');
            resultMessageContent.textContent = `Successfully sent ${data.processed} reviews to Slack!`;
        } catch (error) {
            // Show error message
            resultMessage.classList.remove('hidden');
            resultMessageContent.classList.remove('bg-green-100', 'text-green-700');
            resultMessageContent.classList.add('bg-red-100', 'text-red-700');
            resultMessageContent.textContent = 'Error sending mock reviews. Please try again.';
        }

        // Reset button state
        sendMockDataBtn.disabled = false;
        loadingSpinner.classList.add('hidden');
        buttonText.textContent = 'Send Mock Reviews';
    });

    async function checkSlackConfig() {
        try {
            const response = await fetch('/api/health');
            const data = await response.json();
            
            if (data.slack_configured) {
                slackStatus.classList.add('bg-green-500');
                slackStatus.title = 'Slack is properly configured';
            } else {
                slackStatus.classList.add('bg-red-500');
                slackStatus.title = 'Slack configuration is missing';
            }
        } catch (error) {
            slackStatus.classList.add('bg-red-500');
            slackStatus.title = 'Could not verify Slack configuration';
        }
    }
});
