//
//  AST+Operations.swift
//  SwiftKotlinFramework
//
//  Created by Angel Luis Garcia on 09/09/2017.
//

import AST

extension VariableDeclaration {
    var isStatic: Bool {
        return modifiers.isStatic
    }

    var isImplicitlyUnwrapped: Bool {
        return typeAnnotation?.type is ImplicitlyUnwrappedOptionalType
    }
    
    var isOptional: Bool {
        return typeAnnotation?.type is OptionalType
    }

    var typeAnnotation: TypeAnnotation? {
        return initializerList?
            .flatMap { $0.pattern as? IdentifierPattern }
            .flatMap { $0.typeAnnotation }
            .first
    }
    
    var initializerList: [PatternInitializer]? {
        switch body {
        case .initializerList(let patterns):
            return patterns
        default:
            return nil
        }
    }
}

extension FunctionDeclaration {
    var isStatic: Bool {
        return modifiers.isStatic
    }
}

extension StructDeclaration.Member {
    var isStatic: Bool {
        guard let declaration = self.declaration else { return false }
        if let variable = declaration as? VariableDeclaration {
            return variable.isStatic
        }
        if let function = declaration as? FunctionDeclaration {
            return function.isStatic
        }
        return false
    }

    var declaration: Declaration? {
        guard case .declaration(let declaration) = self else { return nil }
        return declaration
    }
}

extension ClassDeclaration.Member {
    var isStatic: Bool {
        guard let declaration = self.declaration else { return false }
        if let variable = declaration as? VariableDeclaration {
            return variable.isStatic
        }
        if let function = declaration as? FunctionDeclaration {
            return function.isStatic
        }
        return false
    }

    var declaration: Declaration? {
        guard case .declaration(let declaration) = self else { return nil }
        return declaration
    }
}

extension ExtensionDeclaration.Member {
    var isStatic: Bool {
        guard let declaration = self.declaration else { return false }
        if let variable = declaration as? VariableDeclaration {
            return variable.isStatic
        }
        if let function = declaration as? FunctionDeclaration {
            return function.isStatic
        }
        return false
    }

    var declaration: Declaration? {
        guard case .declaration(let declaration) = self else { return nil }
        return declaration
    }
}

extension Collection where Iterator.Element == DeclarationModifier {
    var isStatic: Bool {
        return self.contains(where: { $0.isStatic })
    }
}

extension DeclarationModifier {
    var isStatic: Bool {
        switch self {
        case .`static`: return true
        default: return false
        }
    }
}

extension SuperclassExpression {
    var isInitializer: Bool {
        switch kind {
        case .initializer:
            return true
        default:
            return false
        }
    }
}

extension SelfExpression {
    var isInitializer: Bool {
        switch kind {
        case .initializer:
            return true
        default:
            return false
        }
    }
}

extension EnumDeclaration.Member {
    
    var unionStyleEnumCase: EnumDeclaration.UnionStyleEnumCase? {
        switch self {
        case .union(let enumCase):
            return enumCase
        default:
            return nil
        }
    }
}


