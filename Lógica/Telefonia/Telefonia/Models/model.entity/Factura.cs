using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace model.entity
{
    public class Factura
    {
        public int ID { get; set; }
        public string Fecha { get; set; }
        public string FechaAPagar { get; set; }
        public decimal SaldoMega { get; set; }
        public decimal SaldoMinutos { get; set; }
        public decimal SaldoMins110 { get; set; }
        public decimal SaldoMins800 { get; set; }
        public decimal SaldoMins900 { get; set; }
        public decimal SaldoTotalPa { get; set; }
        public bool estado { get; set; }

        public Factura() { }

        public Factura (int pid)
        {
            ID = pid;
        }

    }
}