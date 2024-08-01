import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    // MARK: - Private Properties
    
    // переменная с индексом текущего вопроса
    private var currentQuestionIndex = 0
    
    // переменная со счётчиком правильных ответов
    private var correctAnswers = 0
    
    //Наполняем массив QuizQuestion данными (моки)
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
    ]
    
    // MARK: - Structures
    
    // для состояния "Результат квиза"
    private struct QuizResultsViewModel {
      // строка с заголовком алерта
      let title: String
      // строка с текстом о количестве набранных очков
      let text: String
      // текст для кнопки алерта
      let buttonText: String
    }
    
    // вью модель для состояния "Вопрос показан"
    private struct QuizStepViewModel {
        // картинка с афишей фильма с типом UIImage
        let image: UIImage
        // вопрос о рейтинге квиза
        let question: String
        // строка с порядковым номером этого вопроса (ex. "1/10")
        let questionNumber: String
    }
    
    //Создаем структуру вопроса
    private struct QuizQuestion {
        // строка с названием фильма,
        let image: String
        // строка с вопросом о рейтинге фильма
        let text: String
        // ответ на вопрос
        let correctAnswer: Bool
    }
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentQuestion = questions[currentQuestionIndex]
        show(quiz: convert(model: currentQuestion))
    }
    
    // MARK: - IB Actions
    
    @IBAction private func yesButtonClick(_ sender: UIButton) {
        //Логическая переменная если да - то true, если нет - то false
        let correctIndex = true
        
        if questions[currentQuestionIndex].correctAnswer == correctIndex {
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
        
    }
    
    @IBAction private func noButtonClick(_ sender: UIButton) {
        //Логическая переменная если да - то true, если нет - то false
        let correctIndex = false
        
        if questions[currentQuestionIndex].correctAnswer == correctIndex {
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
    }
    
    // MARK: - Private Methods
    
    // приватный метод для показа результатов раунда квиза
    private func show(quiz result: QuizResultsViewModel) {
        // создаём объекты всплывающего окна
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        // константа с кнопкой для системного алерта
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
          // код, который сбрасывает игру и показывает первый вопрос
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            let currentQuestion = self.questions[self.currentQuestionIndex]
            self.show(quiz: self.convert(model: currentQuestion))
        }
        // добавляем в алерт кнопку
        alert.addAction(action)
        // показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
    }
    
    // метод конвертации
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    
    // приватный метод вывода на экран вопроса
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }
    
    // приватный метод, который меняет цвет рамки
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
            imageView.layer.borderWidth = 8 // толщина рамки
            imageView.layer.borderColor = UIColor.yPGreen.cgColor // делаем рамку белой
            imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
            correctAnswers += 1
        } else {
            imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
            imageView.layer.borderWidth = 8 // толщина рамки
            imageView.layer.borderColor = UIColor.yPRed.cgColor // делаем рамку белой
            imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        }
        //задержка в 1 секунду
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            //убрали рамку
            self.imageView.layer.borderWidth = 0
        }
    }
    
    //показываем следующий вопрос или алерт результатов
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 { // 1
            // идём в состояние "Результат квиза"
            let text = "Ваш результат: \(correctAnswers)/10"
            let model = QuizResultsViewModel(
                title: "Раунд окончен",
                text: text,
                buttonText: "Сыграть еще раз")
            show(quiz: model)
        } else { // 2
            currentQuestionIndex += 1
            // идём в состояние "Вопрос показан"
            let currentQuestion = questions[currentQuestionIndex]
            show(quiz: convert(model: currentQuestion))
        }
    }

}
    
