-- rotinas de automação PLSQL

-- atualização automática na tabela energy_tips
DO $$
BEGIN
    CREATE OR REPLACE FUNCTION update_energy_tips_category()
    RETURNS VOID AS $$
    BEGIN
        UPDATE energy_tips
        SET category = CASE
            WHEN tip_text ILIKE '%solar%' THEN 'renewable'
            WHEN tip_text ILIKE '%LED%' THEN 'residential'
            WHEN tip_text ILIKE '%economia%' THEN 'general'
            ELSE 'other'
        END;
    END;
    $$ LANGUAGE plpgsql;

    PERFORM update_energy_tips_category();
END;
$$;


-- remoção de simulações antigas da tabela simulations
DO $$
BEGIN
    CREATE OR REPLACE FUNCTION expire_old_simulations()
    RETURNS VOID AS $$
    BEGIN
        DELETE FROM simulations
        WHERE created_at < NOW() - INTERVAL '12 months';
    END;
    $$ LANGUAGE plpgsql;

    PERFORM expire_old_simulations();
END;
$$;
