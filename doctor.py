"""
POO-Doctor: A simple Object-Oriented Programming example
This module demonstrates OOP concepts with a Doctor class
"""


class Doctor:
    """
    Doctor class that represents a medical doctor with greeting capabilities
    """
    
    def __init__(self, nombre="Doctor", especialidad="General"):
        """
        Initialize a Doctor instance
        
        Args:
            nombre (str): The name of the doctor
            especialidad (str): The medical specialty of the doctor
        """
        self.nombre = nombre
        self.especialidad = especialidad
    
    def saludar(self):
        """
        Greet the patient
        
        Returns:
            str: A greeting message from the doctor
        """
        return f"Hola, soy el Dr. {self.nombre}, especialista en {self.especialidad}"
    
    def __str__(self):
        """
        String representation of the Doctor
        
        Returns:
            str: A string describing the doctor
        """
        return f"Dr. {self.nombre} - {self.especialidad}"


def main():
    """
    Main function to demonstrate the Doctor class
    """
    # Create a doctor instance
    doctor = Doctor("Pérez", "Medicina General")
    
    # Display the greeting
    print(doctor.saludar())
    
    # Create another doctor with default values
    doctor_default = Doctor()
    print(doctor_default.saludar())


if __name__ == "__main__":
    main()
