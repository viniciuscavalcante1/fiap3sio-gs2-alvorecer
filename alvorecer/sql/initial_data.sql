-- seta utf 8 para enviar de forma correta para o banco
SET client_encoding = 'UTF8';


CREATE OR REPLACE FUNCTION insert_default_energy_tips()
RETURNS VOID AS $$
BEGIN
    INSERT INTO energy_tips (tip_text, category)
    SELECT tip_text, category
    FROM (
        VALUES
            ('Desligue os aparelhos da tomada enquanto não estiverem sendo usados!', 'general'),
            ('Use lâmpadas LED, são mais econômicas!', 'residential'),
            ('Invista na energia mais abundante: a solar.', 'renewable'),
            ('Monitore sempre o consumo mensal de energia.', 'general'),
            ('Apague as luzes!', 'residential'),
            ('Lâmpadas, interruptores e tomadas inteligentes podem te ajudar a economizar!', 'residential')
    ) AS tips(tip_text, category)
    WHERE NOT EXISTS (
        SELECT 1
        FROM energy_tips
        WHERE energy_tips.tip_text = tips.tip_text
    );
END;
$$ LANGUAGE plpgsql;

-- insere as dicas padrões
SELECT insert_default_energy_tips();

-- inserir empresas iniciais
CREATE OR REPLACE FUNCTION insert_default_companies()
RETURNS VOID AS $$
BEGIN
    INSERT INTO company_hubs (company_name, services, location, contact)
    SELECT company_name, services, location, contact
    FROM (
        VALUES
            ('Araci Solar', 'Instalação e manutenção de sistemas fotovoltaicos', 'São Paulo', 'https://aracisolar.com.br/'),
            ('Inca Solar', 'Gerador Solar, Manutenção e Monitoramento de Geradores Solar', 'São Paulo', 'https://www.incasolar.com.br/'),
            ('Green Solar', 'Soluções Fotovoltaicas', 'Rio de Janeiro', 'https://greensolar.com.br/'),
            ('Metasol', 'Projeto, instalação e manutenção de energia solar fotovoltaica', 'Minas Gerais', 'https://metalsol.com.br/'),
            ('BVK Energia Solar', 'Energia Solar', 'Espírito Santo', 'https://bvkenergiasolar.com.br/')
    ) AS companies(company_name, services, location, contact)
    WHERE NOT EXISTS (
        SELECT 1
        FROM company_hubs
        WHERE company_hubs.company_name = companies.company_name
    );
END;
$$ LANGUAGE plpgsql;

-- insere as empresas iniciais
SELECT insert_default_companies();

-- inserir dispositivos padrões
CREATE OR REPLACE FUNCTION insert_default_appliances()
RETURNS VOID AS $$
BEGIN
    INSERT INTO appliances (name, average_consumption, category)
    SELECT name, average_consumption, category
    FROM (
        VALUES
            ('Geladeira', 50, 'Eletrodoméstico'),
            ('Ar-condicionado', 150, 'Eletrodoméstico'),
            ('Lâmpada LED', 10, 'Iluminação'),
            ('Máquina de lavar roupa', 100, 'Eletrodoméstico'),
            ('Televisão', 60, 'Entretenimento'),
            ('Computador', 120, 'Tecnologia'),
            ('Micro-ondas', 90, 'Cozinha')
    ) AS devices(name, average_consumption, category)
    WHERE NOT EXISTS (
        SELECT 1
        FROM appliances
        WHERE appliances.name = devices.name
    );
END;
$$ LANGUAGE plpgsql;

-- insere os dispositivos
SELECT insert_default_appliances();

-- insere mock de monitoramento
CREATE OR REPLACE FUNCTION insert_mock_monitoring()
RETURNS VOID AS $$
BEGIN
    INSERT INTO energy_monitoring (user_id, reference_month, consumption_kwh, generated_energy, cost)
    VALUES 
        (4, '2024-01-01', 450, 50, 350.00),
        (4, '2024-02-01', 470, 60, 370.00),
        (4, '2024-03-01', 430, 55, 340.00),
        (4, '2024-04-01', 480, 70, 380.00),
        (4, '2024-05-01', 500, 80, 400.00),
        (4, '2024-06-01', 520, 90, 420.00),
        (4, '2024-07-01', 510, 85, 410.00),
        (4, '2024-08-01', 530, 95, 430.00),
        (4, '2024-09-01', 490, 75, 390.00),
        (4, '2024-10-01', 470, 60, 370.00),
        (4, '2024-11-01', 460, 55, 360.00),
        (4, '2024-12-01', 450, 50, 350.00)
    ON CONFLICT DO NOTHING; 
END;
$$ LANGUAGE plpgsql;

-- insere o mock
SELECT insert_mock_monitoring();
