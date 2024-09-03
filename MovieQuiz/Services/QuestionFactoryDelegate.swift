//
//  File.swift
//  MovieQuiz
//
//  Created by Антон Ищенко on 02.09.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
