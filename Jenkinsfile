pipeline {
    agent any

    stages {
        stage("Git Clone") {
            steps {
                git(
                    credentialsId: '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',
                    branch: 'master',
                    url: 'https://github.com/kunalmundhe24/simple-webapp-flask.git'
                )
                bat "dir /s"  // Debugging: List all files after cloning
            }
        }

        stage('Set Up Python Environment') {
            steps {
                bat '''
                    echo "🔹 Checking if Python is installed..."
                    python --version || exit /b 1

                    echo "🔹 Creating virtual environment if it doesn't exist..."
                    if not exist venv (
                        python -m venv venv
                    )

                    echo "🔹 Activating virtual environment and installing dependencies..."
                    call venv\\Scripts\\activate && (
                        echo "🔹 Upgrading pip..."
                        python -m pip install --upgrade pip

                        if exist requirements.txt (
                            echo "🔹 Installing from requirements.txt..."
                            python -m pip install -r requirements.txt
                        ) else (
                            echo "❌ ERROR: requirements.txt not found!"
                            exit /b 1
                        )
                    )

                    if errorlevel 1 (
                        echo "❌ ERROR: Setup failed!"
                        exit /b 1
                    )
                '''
            }
        }

        stage('Build & Deploy') {
            when {
                expression { return currentBuild.result == null || currentBuild.result == 'SUCCESS' }
            }
            steps {
                bat '''
                    echo "🚀 Deploying the app..."
                    call venv\\Scripts\\activate && (
                        echo "🔹 Checking if app.py exists..."
                        if not exist app.py (
                            echo "❌ ERROR: app.py not found!"
                            exit /b 1
                        )

                        echo "🔹 Starting Flask application..."
                        python app.py
                    )

                    if errorlevel 1 (
                        echo "❌ ERROR: Failed to start Flask application!"
                        exit /b 1
                    )

                    echo "✅ Application deployed successfully!"
                '''
            }
        }
    }

    post {
        always {
            junit 'report.xml'
        }
        failure {
            echo '❌ Test Failed! Stopping Deployment.'
        }
        success {
            echo '✅ All tests passed! Application deployed successfully.'
        }
    }
}
