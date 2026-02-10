# ShiftCover

ShiftCover is a comprehensive web application designed to streamline job shift postings and coverage. It empowers users to post available shifts, cover shifts for others, and complete training modules for professional certifications.

## Features

- **User Authentication**: Secure user registration and login using Devise.
- **Role-Based Access Control**: Authorization managed by Pundit, ensuring secure access to features based on user roles.
- **Shift Management**: Users can post shifts they need covered and pick up shifts posted by others.
- **Training Modules**: Integrated training modules for users to complete certifications.
- **Admin Dashboard**: (If applicable) Administrative tools to manage users and shifts.
- **Direct Messaging**: Communication features for users to coordinate shift coverage.
- **Responsive Design**: Mobile-friendly interface for on-the-go access.

## Technology Stack

- **Ruby**: 3.2.2
- **Framework**: Ruby on Rails 7.1.3
- **Database**: PostgreSQL
- **Frontend**: ERB, Stimulus, Turbo
- **Styling**: Bootstrap/Custom CSS
- **Authentication**: Devise
- **Authorization**: Pundit
- **Pagination**: Kaminari
- **AI Integration**: OpenAI (configured via `ruby-openai` gem)
- **Deployment**: Ready for deployment on platforms like Render or Fly.io

## Prerequisites

Before you begin, ensure you have the following installed on your local machine:

- Ruby 3.2.2
- PostgreSQL
- Redis (for Action Cable and background jobs)
- Node.js and Yarn

## Setup Instructions

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/your-username/shift-cover.git
    cd shift-cover
    ```

2.  **Install dependencies**:
    ```bash
    bundle install
    yarn install
    ```

3.  **Set up the database**:
    ```bash
    rails db:create
    rails db:migrate
    rails db:seed # populates the database with initial data
    ```

4.  **Configure Environment Variables**:
    Create a `.env` file in the root directory and add the following keys:
    ```
    AWS_ACCESS_KEY_ID=your_aws_access_key
    AWS_SECRET_ACCESS_KEY=your_aws_secret_key
    AWS_BUCKET_NAME=your_bucket_name
    AWS_REGION=your_bucket_region
    OPENAI_ACCESS_TOKEN=your_openai_api_key
    ```

5.  **Compile Assets**:
    ```bash
    rails assets:precompile
    ```

6.  **Run the Application**:
    ```bash
    bin/dev
    ```
    or
    ```bash
    rails s
    ```
    Visit `http://localhost:3000` in your browser.

## Testing

To run the test suite:
```bash
bundle exec rspec
```

## Contributing

1.  Fork the repository.
2.  Create a new branch (`git checkout -b feature/YourFeature`).
3.  Commit your changes (`git commit -am 'Add some feature'`).
4.  Push to the branch (`git push origin feature/YourFeature`).
5.  Create a new Pull Request.

## License

This project is open-source and available under the [MIT License](LICENSE).
