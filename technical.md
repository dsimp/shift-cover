# SDF Final Project Rubric - Technical
This is intended to be filled out by staff members of DPI Tech Apprenticeship program.

- Date/Time:
- Trainee Name:
- Project Name:
- Reviewer Name:
- Repository URL:
- Feedback Pull Request URL:

## Readme (max: 10 points)
- [x] **Markdown**: Is the README formatted using Markdown?
- [x] **Naming**: Is the repository name relevant to the project?
- [x] **1-liner**: Is there a 1-liner briefly describing the project?
- [x] **Instructions**: Are there detailed setup and installation instructions, ensuring a new developer can get the project running locally without external help?
- [x] **Configuration**: Are configuration instructions provided, such as environment variables or configuration files that need to be set up?
- [ ] **Contribution**: Are there clear contribution guidelines? Do they outline how developers can contribute to the project, including coding conventions, branch naming conventions, and the pull request process?
- [x] **ERD**: Does the documentation include an entity relationship diagram?
- [ ] **Troubleshooting**: Is there an FAQs or Troubleshooting section that addresses common issues, questions, or obstacles users or new contributors might face?
- [ ] **Visual Aids**: Are there visual aids (diagrams, screenshots, etc.) that would help developers quickly ramp on to the project?
- [ ] **API Documentation (for projects providing their own API endpoints)**: Is there clear and detailed documentation for the project's API? This should include descriptions of all endpoints, request/response formats, and authentication methods.

### Score (6/10):

### Notes:

## Version Control (max: 10 points)
- [x] **Version Control**: Is the project using a version control system such as Git?
- [x] **Repository Management**: Is the repository hosted on a platform like GitHub, GitLab, or Bitbucket, making it accessible for collaboration and review?
- [x] **Commit Quality**: Does the project have regular commits with clear, descriptive messages?
- [x] **Pull Requests**: Does the project employ a clear branching and merging strategy, such as Git Flow, to organize development and feature integration?
- [x] **Issues**: Is the project utilizing issue tracking to manage tasks and bugs?
- [x] **Linked Issues**: Are these issues linked to pull requests (PRs)? (at least once)
- [ ] **Project Board**: Does the project utilize a project board (e.g., GitHub Projects or Trello) to manage and prioritize work items? (linked to repository or readme, and public)
- [x] **Code Review Process**: Is there evidence of a code review process, with pull requests reviewed by peers or mentors **before** merging (at least once), ensuring code quality and collaborative learning?
- [x] **Branch Protection**: Are the main branches (e.g., master, main) protected to prevent direct commits and ensure code quality?
- [ ] **Continuous Integration/Continuous Deployment (CI/CD)**: Has the project implemented CI/CD pipelines (using tools like GitHub Actions) to automate testing and deployment?

### Score (/10):

### Notes:

## Code Hygiene (max: 8 points)
- [ ] **Indentation**: Is the code consistently indented throughout the project?
- [x] **Naming Conventions**: Are naming conventions (e.g., variable names, method names, class names) clear, consistent, and descriptive?
- [x] **Casing Conventions**: Are casing conventions (e.g., camelCase for JavaScript, snake_case for Ruby, PascalCase for Ruby Classes) consistent throughout the project? 
- [x] **Layouts**: Is the code utilizing Rails' `application.html.erb` layout effectively, ensuring that it provides consistent and reusable templates for the application's views?
- [x] **Code Clarity**: Is the code easy to read and understand? Look for simple, straightforward implementations and avoid unnecessary complexity. 
- [x] **Comment Quality**: Does the code include inline comments that explain "why" behind non-obvious logic? Over-commenting should be avoided; code should be self-explanatory wherever possible. 
- [x] **Minimal Unused Code**: Unused code should be deleted (not commented out).
- [ ] **Linter**: Is a linter (e.g., Rubocop, ESLint) used and configured to enforce code style and quality standards?

### Score (/8):

### Notes:

## Patterns of Enterprise Applications (max: 10 points)
- [x] **Domain Driven Design**: Does the application follow domain-driven design principles, with clear separation of concerns and a focus on the core domain logic?
- [x] **Advanced Data Modeling**: Has the application utilized ActiveRecord callbacks for model lifecycle management?
- [x] **Component-Based View Templates**: Does the application use component-based view templates (partials) to promote reusability and maintainability?
- [x] **Backend Modules**: Does the application effectively use modules (concerns, etc.) to encapsulate related functionality and promote code organization?
- [ ] **Frontend Modules**: Does the application effectively use modules (es6, etc.) to encapsulate related functionality and promote code organization?
- [x] **Service Objects**: Does the application abstract logic into service objects when appropriate?
- [ ] **Polymorphism**: Does the application use polymorphism to create flexible and maintainable code?
- [x] **Event-Driven Architecture**: Does the application use event-driven architecture (e.g., pub-sub) to decouple components and improve scalability? (for example ActionCable https://guides.rubyonrails.org/action_cable_overview.html)
- [x] **Overall Separation of Concerns**: Are the concerns of the application (e.g., data access, business logic, presentation) separated effectively, with each layer focused on its specific responsibilities?
- [x] **Overall DRY Principle**: Does the application follow the DRY (Don't Repeat Yourself) principle, with code reuse and minimal redundancy?

### Score (/10):

### Notes:

## Design (max: 5 points)
- [x] **Readability**: Ensure the text is easily readable. Avoid color combinations that make text difficult to read (e.g., white text on a bright pink background).
- [x] **Line length**: The horizontal width of text blocks should be no more than 2–3 lowercase alphabets.
- [x] **Font Choices**: Use appropriate font sizes, weights, and styles to enhance readability and visual appeal.
- [x] **Consistency**: Maintain consistent font usage and colors throughout the project.
- [x] **Double Your Whitespace**: Ensure ample spacing around elements to enhance readability and visual clarity. Avoid cluttered layouts by doubling the whitespace where appropriate.

### Score (/5):

### Notes:

## Frontend (max: 10 points)
- [ ] **Mobile/Tablet Design**: It looks and works great on mobile/tablet (using media queries or CSS framework). Layouts should be responsive and user-friendly, not only shrunk down versions of the desktop site.
- [x] **Desktop Design**: It looks and works great on desktop.
- [x] **Styling**: Does the frontend employ CSS or CSS frameworks (like Bootstrap) for styling? Inline CSS should not be overrused.
- [x] **Semantic HTML**: Is the project making effective use of semantic HTML elements to structure the content, ensuring that it's both accessible and SEO-friendly (e.g., using `<header>`, `<footer>`, `<nav>`, or `<main>` when applicable. See https://www.w3schools.com/html/html5_semantic_elements.asp for more detail)
- [x] **Feedback**: Are styled flashes or toasts implemented in a partial to provide clear, user-feedback?
- [ ] **Client-Side Interactivity**: Is JavaScript or JavaScript frameworks/libraries (e.g., jQuery, Stimulus, etc.) utilized to reduce unnecessary page reloads and provide a rich client side experience for key features of the app?
- [ ] **AJAX**: Is Asynchronous JavaScript (and XML) used to perform a CRUD action and update the UI?
- [x] **Form Validation**: Does the project include client-side form validation to provide immediate feedback to users and reduce server requests?
- [x] **Accessibility: alt tags**: Are alt tags implemented to support users who rely on screen readers and to comply with web accessibility standards?
- [] **Accessibility: ARIA roles**: Are ARIA roles implemented to support users who rely on screen readers and to comply with web accessibility standards?

### Score (/10):

### Notes:

## Backend (max: 9 points)
- [x] **CRUD**: Does the application implement at least one resource with full CRUD functionality?
- [x] **MVC pattern**: Does the application follow the Model-View-Controller pattern, with skinny controllers and rich models?
- [x] **RESTful Routes**: Are the routes RESTful, with clear and consistent naming conventions?
- [ ] **DRY queries**: Are database queries primarily implemented in the model layer rather than in the views or controllers, following the separation of concerns principle, keeping views lightweight and focused on presentation logic, and controllers thin?
- [x] **Data Model Design**: Is the data model well-designed, clear, and efficient, facilitating easy data manipulation and retrieval, while avoiding redundancy and promoting data integrity?
- [x] **Associations**: Does the application efficiently use Rails association methods (belongs_to, has_many, etc.) to organize data relationships?
- [x] **Validations**: Are validations implemented to ensure data integrity and consistency?
- [ ] **Query Optimization**: Does the application use scopes to perform optimized database queries?
- [x] **Database Management**: Are additional features such as file upload (CSV) or custom rake tasks for database management included? (e.g. slurp.rake task)

### Score (/9):

### Notes:

## Quality Assurance and Testing (max: 2 points)
- [ ] **End to End Test Plan**: Does the project include an end to end test plan?
- [ ] **Automated Testing**: Does the project include a test suite (e.g., RSpec, Minitest, Jest, etc.) that covers key flows or logic components?

### Score (/2):

### Notes:

## Security and Authorization (max: 5 points)
- [x] **Credentials**: Are API keys and sensitive information securely stored (using .env or Rails credentials)?
- [ ] **HTTPS**: Is HTTPS enforced? (config.force_ssl = true)?
- [x] **Sensitive attributes**: Are sensitive attributes assigned in the model or controller when necessary (e.g. current_user), and not through hidden fields?
- [x] **Strong Params**: Are strong parameters used to prevent form vulnerabilities?
- [x] **Authorization**: Is an authorization framework (such as Pundit) employed to manage user permissions and ensure secure access control throughout the application?

### Score (/5):

### Notes:

## Features (each: 1 point - max: 15 points)
- [ ] **Sending Email**: Does the application send transactional emails (e.g., welcome emails, password reset emails) to users?
- [ ] **Sending SMS**: Does the application send transactional SMS messages to users?
- [ ] **Building for Mobile**: Implementation of a Progressive Web App (PWA) to provide a mobile app-like experience on the web.
- [ ] **Advanced Search and Filtering**: Incorporation of advanced search and filtering capabilities (Ransack or similar) to improve data retrieval and user experience.
- [ ] **Data Visualization**: Integration of charts, graphs, or other visual representations of data (Chartkick or similar) to provide insightful views of data to the user.
- [ ] **Dynamic Meta Tags**: Dynamic generation of meta tags for social media previews and SEO optimization, enhancing the application's presence on the web.
- [ ] **Pagination**: Use of pagination libraries (Kaminari, will_paginate, or similar) to manage large sets of data efficiently on the UI.
- [ ] **Internationalization (i18n)**: Support for multiple languages using internationalization techniques, making the app accessible to a global audience.
- [ ] **Admin Dashboard**: Creation of an admin panel to provide valuable administrative capabilities (Rails Admin or similar).
- [ ] **Business Insights Dashboard**: Creation of an insights dashboard to provide valuable business intelligence capabilities (Blazer or similar).
- [ ] **Enhanced Navigation**: Are breadcrumbs (or similar) used to enhance site navigation?
- [ ] **Performance Optimization**: Is the Bullet gem (or similar) used in development to detect and reduce N+1 queries and other common performance bottlenecks?
- [ ] **Stimulus**: Implementation of Stimulus.js to enhance interactivity and user experience on the frontend.
- [ ] **Turbo Frames**: Implementation of Turbo Frames to enhance the performance of the application by updating only parts of the page.
- [ ] **Other**: Any other features or functionalities that enhance the application's value and user experience (specify in notes below).

### Score (/15):

### Notes:


## Ambitious Features (each: 2 points - max: 16 points)
- [ ] **Receiving Email**: Does the application handle incoming emails? (eg `ActionMailbox`)
- [ ] **Inbound SMS**: Does the application handle receiving SMS messages? (eg Twilio)
- [ ] **Web Scraping Capabilities**: Incorporation of web scraping functionality to extract data from external websites.
- [x] **Background Processing**: Are background jobs (eg `ActiveJob`) implemented for time-consuming processes, improving app performance and user experience?
- [ ] **Mapping and Geolocation**: Use of mapping or geocoding libraries (e.g., Mapbox, Geocoder) to add location-based features to the application.
- [x] **Cloud Storage Integration**: Integration with cloud storage services (e.g., AWS S3) for handling file uploads and storage.
- [x] **Chat GPT or AI Integration**: Implementation of Chat GPT or other AI services to provide intelligent responses or features. 
- [ ] **Payment Processing**: Implementation of a payment gateway (e.g., Stripe) for secure online transactions.
- [ ] **OAuth**: Implementation of OAuth for secure, third-party authentication.
- [ ] **Other**: Any other features or functionalities that enhance the application's value and user experience (specify in notes below).

### Score (/16):

### Notes:

## Technical Score (/100):
- Readme (/10):
- Version Control (/10):
- Code Hygiene (/8):
- Patterns of Enterprise Applications (/10):
- Design (/5):
- Frontend (/10):
- Backend (/9):
- Quality Assurance and Testing (/2):
- Security and Authorization (/5):
- Features (/15):
- Ambitious Features (/16):
---
- Total: 

## Additional overall comments for the entire review may be added below:
```



```
