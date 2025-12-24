//
//  NetworkError.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//


enum NetworkError: Error {
    case invalidResponse
    case serverError(String)
}