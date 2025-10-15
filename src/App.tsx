import { useState } from "react";
import reactLogo from "./assets/react.svg";
import viteLogo from "/vite.svg";
import "./App.css";

function App() {
  const [activeStep, setActiveStep] = useState(0);

  const jenkinsSteps = [
    {
      title: "Source Code Repository",
      description: "Code is stored in GitHub/GitLab repositories",
      icon: "📁",
      details:
        "Developers push code changes to version control systems like GitHub, triggering automated workflows.",
    },
    {
      title: "Webhook Trigger",
      description: "GitHub webhook notifies Jenkins of new commits",
      icon: "🔗",
      details:
        "When code is pushed, a webhook automatically notifies Jenkins to start the CI/CD pipeline.",
    },
    {
      title: "Jenkins Pipeline",
      description: "Jenkins pulls code and runs automated tasks",
      icon: "⚙️",
      details:
        "Jenkins executes predefined jobs: code checkout, dependency installation, testing, and building.",
    },
    {
      title: "Build & Test",
      description: "Code is compiled, tested, and packaged",
      icon: "🔨",
      details:
        "Automated tests run to ensure code quality, then the application is built into deployable artifacts.",
    },
    {
      title: "Cloud Deployment",
      description: "Application is deployed to cloud platforms",
      icon: "☁️",
      details:
        "Successfully built applications are automatically deployed to cloud services like AWS, Azure, or Render.",
    },
  ];

  return (
    <div className="jenkins-learning-app">
      <header className="app-header">
        <div className="logo-section">
          <img src={viteLogo} className="logo" alt="Vite logo" />
          <img src={reactLogo} className="logo react" alt="React logo" />
        </div>
        <h1>🚀 Jenkins CI/CD Cloud Learning Platform</h1>
        <p className="subtitle">
          Learn how Jenkins automates deployment in the cloud
        </p>
      </header>

      <main className="main-content">
        <section className="project-info">
          <div className="info-card">
            <h2>📚 About This Project</h2>
            <p>
              This React application demonstrates how{" "}
              <strong>Jenkins CI/CD pipelines</strong> work in cloud
              environments. It's a hands-on learning project that shows the
              complete journey from code commit to cloud deployment.
            </p>
            <div className="tech-stack">
              <span className="tech-badge">React</span>
              <span className="tech-badge">Vite</span>
              <span className="tech-badge">Jenkins</span>
              <span className="tech-badge">Cloud Deployment</span>
            </div>
          </div>
        </section>

        <section className="jenkins-workflow">
          <h2>🔄 Jenkins CI/CD Workflow</h2>
          <div className="workflow-container">
            {jenkinsSteps.map((step, index) => (
              <div
                key={index}
                className={`workflow-step ${
                  index === activeStep ? "active" : ""
                }`}
                onClick={() => setActiveStep(index)}
              >
                <div className="step-header">
                  <span className="step-icon">{step.icon}</span>
                  <h3>{step.title}</h3>
                </div>
                <p className="step-description">{step.description}</p>
                {index === activeStep && (
                  <div className="step-details">
                    <p>{step.details}</p>
                  </div>
                )}
                {index < jenkinsSteps.length - 1 && (
                  <div className="step-arrow">→</div>
                )}
              </div>
            ))}
          </div>
        </section>

        <section className="learning-outcomes">
          <h2>🎯 What You'll Learn</h2>
          <div className="outcomes-grid">
            <div className="outcome-card">
              <h3>🛠️ CI/CD Fundamentals</h3>
              <p>Understand continuous integration and deployment principles</p>
            </div>
            <div className="outcome-card">
              <h3>☁️ Cloud Deployment</h3>
              <p>Learn how applications are deployed to cloud platforms</p>
            </div>
            <div className="outcome-card">
              <h3>🔧 Jenkins Configuration</h3>
              <p>Master Jenkins pipeline setup and automation</p>
            </div>
            <div className="outcome-card">
              <h3>🚀 DevOps Practices</h3>
              <p>Apply modern DevOps workflows in real projects</p>
            </div>
          </div>
        </section>

        <section className="interactive-demo">
          <div className="demo-card">
            <h2>🎮 Interactive Demo</h2>
            <p>
              Click on any workflow step above to see detailed explanations!
            </p>
            <div className="current-step-info">
              <h3>Currently Viewing: {jenkinsSteps[activeStep].title}</h3>
              <p>{jenkinsSteps[activeStep].details}</p>
            </div>
          </div>
        </section>
      </main>

      <footer className="app-footer">
        <p>💡 This project demonstrates real-world Jenkins CI/CD practices</p>
        <p>🌐 Perfect for learning cloud-based development workflows</p>
      </footer>
    </div>
  );
}

export default App;
