import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - IB Outlets
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var noButton: UIButton!
    
    // MARK: - Private Properties
    
    //общее кол-во вопросов для квиза
    private let questionsAmount: Int = 10
    //фабрика вопросов. Контроллер будет обращаться за вопросами к ней.
    //private var questionFactory: QuestionFactory = QuestionFactory()
    private var questionFactory: QuestionFactoryProtocol?
    //вопрос, который видит пользователь
    private var currentQuestion: QuizQuestion?
    
    // переменная с индексом текущего вопроса
    private var currentQuestionIndex: Int = .zero
    // переменная со счётчиком правильных ответов
    private var correctAnswers: Int = .zero
    
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questionFactory = QuestionFactory() // 2
            questionFactory.delegate = self         // 3
            self.questionFactory = questionFactory  // 4
        
        questionFactory.requestNextQuestion() 
            
            
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        // проверка, что вопрос не nil
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        show(quiz: viewModel)
        //обработка на главной очереди
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - IB Actions
    
    @IBAction private func yesButtonClick(_ sender: UIButton) {
        // Булевое значение, ответ совпадает ли  с  `true`
        guard let currentQuestion = currentQuestion else {
            return
        }
        let answer = currentQuestion.correctAnswer == true
        // Передаем вычисляемое значение в `showAnswerResult`
        showAnswerResult(isCorrect: answer)
    }
    
    @IBAction private func noButtonClick(_ sender: UIButton) {
        //Логическая переменная если да - то true, если нет - то false
        guard let currentQuestion = currentQuestion else {
            return
        }
        let answer = currentQuestion.correctAnswer == false
        showAnswerResult(isCorrect: answer)
    }
    
    // MARK: - Private Methods
    
    // приватный метод для показа результатов раунда квиза
    private func show(quiz result: QuizResultsViewModel) {
        // создаём объекты всплывающего окна
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        // константа с кнопкой для системного алерта
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else {return}
            // код, который сбрасывает игру и показывает первый вопрос
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            questionFactory?.requestNextQuestion()
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
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
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
        //заблокировали кнопки Да и Нет
        enableOrDisableButtons()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 8
        
        imageView.layer.borderColor = isCorrect ? UIColor.yPGreen.cgColor : UIColor.yPRed.cgColor
        if isCorrect {
            correctAnswers += 1
        }
        //задержка в 1 секунду
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            
            self.showNextQuestionOrResults()
            //убрали рамку
            self.imageView.layer.borderWidth = 0
            //Разблокировали кнопки Да и Нет
            self.enableOrDisableButtons()
        }
        
    }
    
    //показываем следующий вопрос или алерт результатов
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let text = correctAnswers == questionsAmount ?
                        "Поздравляем, вы ответили на 10 из 10!" :
                        "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            let model = QuizResultsViewModel(
                title: "Раунд окончен",
                text: text,
                buttonText: "Сыграть еще раз")
            show(quiz: model)
        } else { // 2
            currentQuestionIndex += 1
            // идём в состояние "Вопрос показан"
            questionFactory?.requestNextQuestion() 
        }
    }
    
    //включаем или отключаем активность кнопок YES и No
    private func enableOrDisableButtons() {
        noButton.isEnabled.toggle()
        yesButton.isEnabled.toggle()
    }
}


