using System.Collections.Generic;
using System.Web.Mvc;
using model.dao;
using model.entity;

namespace Telefonia.Controllers
{
    public class FacturaController : Controller
    {
        private FacturaDao objFactura;
        public FacturaController()
        {
            objFactura = new FacturaDao();
        }
        // GET: Factura
        public ActionResult List()
        {
            string tel = Request["Rtelefo"];
            string estado = Request["Restado"];
            if (estado == "1")
            {
                estado = "1";
                TempData["strestado"] = "Pagadas";
            }
            else
            {
                TempData["strestado"] = "Pendientes";
            }
            List<Factura> listF = objFactura.findAll(tel, estado);
            return View(listF);
        }

        public ActionResult Details(int ID)
        {
            Factura factura = new Factura(ID);
            return View(factura);
        }
    }
}