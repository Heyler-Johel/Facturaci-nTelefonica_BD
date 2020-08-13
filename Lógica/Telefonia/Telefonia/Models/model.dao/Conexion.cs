using System;
using System.Collections.Generic;
using System.Data.SqlClient; // Para las conexiones
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace model.dao
{
    public class Conexion
    {
        //patron singleton
        private static Conexion objConexion = null;
        private SqlConnection conexion;

        private Conexion()
        {
            conexion = new SqlConnection("Data Source=LAPTOP-NFUCADGT;Initial Catalog=FacturacionMunicipal;Integrated Security=True");
            //conexion = new SqlConnection("Data Source=DESKTOP-T525H9P;Initial Catalog=FacturacionMunicipal;Integrated Security=True");
        }

        public static Conexion saberEstado()
        {
            if (objConexion == null)
            {
                objConexion = new Conexion();
            }
            return objConexion;
        }

        public SqlConnection getConexion()
        {
            return conexion;
        }
        public void cerrarConexion()
        {
            objConexion = null;
        }
    }
}
