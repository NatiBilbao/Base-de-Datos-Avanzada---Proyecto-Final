-- Índices para la tabla Pacientes
CREATE INDEX idx_pacientes_nombre ON Pacientes(nombre);
CREATE INDEX idx_pacientes_fecha_nacimiento ON Pacientes(fecha_nacimiento);

-- Índices para la tabla Profesionales_de_Salud
CREATE INDEX idx_profesionales_nombre ON Profesionales_de_Salud(nombre);
CREATE INDEX idx_profesionales_apellido ON Profesionales_de_Salud(apellido);
CREATE INDEX idx_profesionales_id_especialidad ON Profesionales_de_Salud(id_especialidad);

-- Índices para la tabla Citas
CREATE INDEX idx_citas_id_paciente ON Citas(id_paciente);
CREATE INDEX idx_citas_id_profesional ON Citas(id_profesional);
CREATE INDEX idx_citas_id_centro ON Citas(id_centro);
CREATE INDEX idx_citas_fecha ON Citas(fecha);

-- Índices para la tabla Centros_de_Salud
CREATE INDEX idx_centros_nombre ON Centros_de_Salud(nombre);
CREATE INDEX idx_centros_id_localidad ON Centros_de_Salud(id_localidad);

-- Índices para la tabla Localidades
CREATE INDEX idx_localidades_nombre ON Localidades(nombre);

-- Índices para la tabla Contactos
CREATE INDEX idx_contactos_telefono ON Contactos(telefono);
CREATE INDEX idx_contactos_email ON Contactos(email);

EXPLAIN SELECT * FROM Pacientes WHERE nombre = 'Gloria Garza';
EXPLAIN SELECT * FROM Profesionales_de_Salud WHERE id_especialidad = 1;
EXPLAIN SELECT * FROM Citas WHERE id_paciente = 1;




-- Stored Procedure para obtener citas por paciente
DELIMITER //
CREATE PROCEDURE ObtenerCitasPorPaciente(IN paciente_id INT)
BEGIN
    SELECT Citas.id, Citas.fecha, Profesionales_de_Salud.nombre AS profesional, Centros_de_Salud.nombre AS centro, Motivos.descripcion AS motivo
    FROM Citas
    JOIN Profesionales_de_Salud ON Citas.id_profesional = Profesionales_de_Salud.id
    JOIN Centros_de_Salud ON Citas.id_centro = Centros_de_Salud.id
    JOIN Motivos ON Citas.id_motivo = Motivos.id
    WHERE Citas.id_paciente = paciente_id;
END //
DELIMITER ;

-- Stored Procedure para obtener profesionales por especialidad
DELIMITER //
CREATE PROCEDURE ObtenerProfesionalesPorEspecialidad(IN especialidad_id INT)
BEGIN
    SELECT Profesionales_de_Salud.id, Profesionales_de_Salud.nombre, Profesionales_de_Salud.apellido, Contactos.telefono, Contactos.email
    FROM Profesionales_de_Salud
    JOIN Contactos ON Profesionales_de_Salud.id_contacto = Contactos.id
    WHERE Profesionales_de_Salud.id_especialidad = especialidad_id;
END //
DELIMITER ;

-- Stored Procedure para obtener centros de salud por localidad
DELIMITER //
CREATE PROCEDURE ObtenerCentrosPorLocalidad(IN localidad_id INT)
BEGIN
    SELECT Centros_de_Salud.id, Centros_de_Salud.nombre, Centros_de_Salud.direccion, Contactos.telefono, Contactos.email
    FROM Centros_de_Salud
    JOIN Contactos ON Centros_de_Salud.id_contacto = Contactos.id
    WHERE Centros_de_Salud.id_localidad = localidad_id;
END //
DELIMITER ;

-- Stored Procedure para insertar una nueva cita
DELIMITER //
CREATE PROCEDURE InsertarCita(
    IN paciente_id INT,
    IN profesional_id INT,
    IN centro_id INT,
    IN fecha TIMESTAMP,
    IN motivo_id INT
)
BEGIN
    INSERT INTO Citas (id_paciente, id_profesional, id_centro, fecha, id_motivo, created_at, updated_at)
    VALUES (paciente_id, profesional_id, centro_id, fecha, motivo_id, NOW(), NOW());
END //
DELIMITER ;

-- Stored Procedure para actualizar datos de un paciente
DELIMITER //
CREATE PROCEDURE ActualizarPaciente(
    IN paciente_id INT,
    IN nuevo_nombre VARCHAR(255),
    IN nueva_fecha_nacimiento DATE,
    IN nueva_direccion VARCHAR(255),
    IN nuevo_contacto_id INT
)
BEGIN
    UPDATE Pacientes
    SET nombre = nuevo_nombre,
        fecha_nacimiento = nueva_fecha_nacimiento,
        direccion = nueva_direccion,
        id_contacto = nuevo_contacto_id,
        updated_at = NOW()
    WHERE id = paciente_id;
END //
DELIMITER ;

-- Verificar ObtenerCitasPorPaciente
CALL ObtenerCitasPorPaciente(20);

-- Verificar ObtenerProfesionalesPorEspecialidad
CALL ObtenerProfesionalesPorEspecialidad(1);

-- Verificar ObtenerCentrosPorLocalidad
CALL ObtenerCentrosPorLocalidad(1);

-- Verificar InsertarCita
CALL InsertarCita(1, 1, 1, '2024-07-01 10:00:00', 1);

-- Verificar ActualizarPaciente
CALL ActualizarPaciente(1, 'John Doe', '1980-01-01', '123 Main St', 1);

