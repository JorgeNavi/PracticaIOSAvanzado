//
//  PIAObservable.swift
//  PracticaIOSAvanzado
//
//  Created by Jorge Navidad Espliego on 17/10/24.
//
import Foundation

//esta clase nos va a servir para poder observar los cambios sobre un tipo de dato
class PIAObservable<ObservedType> {
    
    //Esto es una manera de trabajar con variables de las que uno mismo quiere encargarse de su valor, teniendo una variable privada "value" (a la que se pone el _ para marcar que es la privada y que no se pisen los nombres de las variables) y una variable "value" pública:
    private var _value: ObservedType
    private var valueChanged: ((ObservedType) -> Void)?
    
    var value: ObservedType { //en la variable pública vamos a poder asignarle un valor que se lo estamos asignando a la variable privada en la línea 20
        get {
            return _value //si solo queremos recuperar el valor de "value", recuperamos el valor de "_value"
        }
        set {
            DispatchQueue.main.async {
                self._value = newValue //pero si queremos asignarle valor, se lo asignamos a "_value"
                self.valueChanged?(self._value) //Y aqui decimos que el valor a cambiado a "_value" que llegados a esta línea es el valor de newValue. Esto se hace para que no se tenga acceso a la variable privada.
                //La clave es exclusivamente poder notificar cambios en el el valor usando valueChanged. La variable que nos importa es la privada y la pública es unicamente para recoger el cambio en el valor
            }
        }
    }
    
    init(_ value: ObservedType) {
        self._value = value //aqui se le asigna el value a _value con la lógica de la variable pública, por eso ha de inicializarse el observable dándole un value que lance la lógica y le de valor a _value
    }
    
    func bind(completion: ((ObservedType) -> Void)?) {
        valueChanged = completion
    }
    
}
