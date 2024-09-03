//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Антон Ищенко on 01.09.2024.
//

import Foundation

//Создаем структуру вопроса
struct QuizQuestion {
    // строка с названием фильма,
    let image: String
    // строка с вопросом о рейтинге фильма
    let text: String
    // ответ на вопрос
    let correctAnswer: Bool
}
