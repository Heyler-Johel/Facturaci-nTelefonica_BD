using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using model.entity;

namespace model.dao
{
    

    public class FacturaDao
    {
        private Conexion objConexion;
        private SqlCommand comando;

        public FacturaDao()
        {
            objConexion = Conexion.saberEstado();
        }

        public List<Factura> findAll(string tel, string estado)
        {
            List<Factura> listaFactura = new List<Factura>();

            try
            {
                comando = new SqlCommand("spObtenerFacturas", objConexion.getConexion())
                {
                    CommandType = CommandType.StoredProcedure
                };
                comando.Parameters.AddWithValue("@Tel", tel);
                comando.Parameters.AddWithValue("@Estado", estado);
                objConexion.getConexion().Open();
                SqlDataReader read = comando.ExecuteReader();
                while (read.Read())
                {
                    Factura objetoFactura = new Factura
                    {
                        ID = Convert.ToInt32(read[0].ToString()),
                        Fecha = read[1].ToString()
                    };
                    listaFactura.Add(objetoFactura);
                }
            }

            catch (Exception)
            {
                throw;
            }
            finally
            {
                objConexion.getConexion().Close();
                objConexion.cerrarConexion();
            }
            return listaFactura;
        }

        public void find(Factura objetoFactura)
        {
            bool hayRegistros;
            try
            {
                comando = new SqlCommand("spVerFactura", objConexion.getConexion());
                comando.CommandType = CommandType.StoredProcedure;
                comando.Parameters.AddWithValue("@ID", objetoFactura.ID);
                objConexion.getConexion().Open();
                SqlDataReader read = comando.ExecuteReader();
                hayRegistros = read.Read();
                if (hayRegistros)
                {
                    objetoFactura.ID = Convert.ToInt32(read[0].ToString());
                    objetoFactura.Fecha = read[1].ToString();
                    objetoFactura.FechaAPagar = read[2].ToString();
                    objetoFactura.SaldoMega = Convert.ToDecimal(read[3].ToString());
                    objetoFactura.SaldoMins110 = Convert.ToDecimal(read[4].ToString());
                    objetoFactura.SaldoMins800 = Convert.ToDecimal(read[5].ToString());
                    objetoFactura.SaldoMins900 = Convert.ToDecimal(read[6].ToString());
                    objetoFactura.SaldoTotalPa = Convert.ToDecimal(read[7].ToString());
                }
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                objConexion.getConexion().Close();
                objConexion.cerrarConexion();
            }
            return;
        }
    }
}