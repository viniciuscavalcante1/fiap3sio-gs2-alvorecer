-- criação das tabelas usadas no banco de dados

DO $$
BEGIN
    -- tabela Users
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'users') THEN
        CREATE TABLE users (
            user_id SERIAL PRIMARY KEY,
            name VARCHAR(100) NOT NULL,
            email VARCHAR(100) UNIQUE NOT NULL,
            password_hash VARCHAR(255) NOT NULL,
            created_at TIMESTAMP DEFAULT NOW()
        );
    END IF;

    -- tabela Simulations
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'simulations') THEN
        CREATE TABLE simulations (
            simulation_id SERIAL PRIMARY KEY,
            user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
            tariff FLOAT NOT NULL,
            estimated_savings FLOAT,
            created_at TIMESTAMP DEFAULT NOW()
        );
    END IF;

    -- tabela Energy Monitoring
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'energy_monitoring') THEN
        CREATE TABLE energy_monitoring (
            monitoring_id SERIAL PRIMARY KEY,
            user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
            reference_month DATE NOT NULL,
            consumption_kwh FLOAT NOT NULL,
            generated_energy FLOAT,
            cost FLOAT
        );
    END IF;

    -- tabela Appliances
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'appliances') THEN
        CREATE TABLE appliances (
            appliance_id SERIAL PRIMARY KEY,
            name VARCHAR(100) NOT NULL,
            average_consumption FLOAT NOT NULL,
            category VARCHAR(50)
        );
    END IF;

    -- tabela Companies
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'company_hubs') THEN
        CREATE TABLE company_hubs (
            company_id SERIAL PRIMARY KEY,
            company_name VARCHAR(100) NOT NULL,
            services TEXT NOT NULL,
            location VARCHAR(100),
            contact VARCHAR(100)
        );
    END IF;

    -- tabela Energy tips
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'energy_tips') THEN
        CREATE TABLE energy_tips (
            tip_id SERIAL PRIMARY KEY,
            tip_text VARCHAR(255) NOT NULL,
            category VARCHAR(50)
        );
    END IF;
END;
$$;