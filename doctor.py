"""
POO-Doctor: A simple Object-Oriented Programming example
This module demonstrates OOP concepts with a Doctor class
"""


class Doctor:
    """
    Doctor class that represents a medical doctor with greeting capabilities
    """
    
    def __init__(self, nombre="Doctor", especialidad="General", titulo="Dr."):
        """
        Initialize a Doctor instance
        
        Args:
            nombre (str): The name of the doctor
            especialidad (str): The medical specialty of the doctor
            titulo (str): The title of the doctor (e.g., "Dr.", "Dra.", "Dr./Dra.")
        """
        self.nombre = nombre
        self.especialidad = especialidad
        self.titulo = titulo
    
    def saludar(self):
        """
        Greet the patient
        
        Returns:
            str: A greeting message from the doctor
        """
        return f"Hola, soy {self.titulo} {self.nombre}, especialista en {self.especialidad}"
    
    def __str__(self):
        """
        String representation of the Doctor
        
        Returns:
            str: A string describing the doctor
        """
        return f"{self.titulo} {self.nombre} - {self.especialidad}"


def main():
    """
    Main function to demonstrate the Doctor class
    """
    # Create a doctor instance
    doctor = Doctor("Pérez", "Medicina General")
    
    # Display the greeting
    print(doctor.saludar())
    
    # Create a female doctor with Dra. title
    doctora = Doctor("García", "Pediatría", "Dra.")
    print(doctora.saludar())
    
    # Create another doctor with default values
    doctor_default = Doctor()
    print(doctor_default.saludar())


if __name__ == "__main__":
    main()
